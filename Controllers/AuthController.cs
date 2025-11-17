using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using LlmApi.Contracts.Authentication;   // RegisterRequest, LoginRequest, AuthResponse
using LlmApi.Models;                    // User
using LlmApi.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace LlmApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IUserService _userService;
        private readonly IConfiguration _configuration;

        public AuthController(IUserService userService, IConfiguration configuration)
        {
            _userService = userService;
            _configuration = configuration;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest request)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            if (string.IsNullOrWhiteSpace(request.FirstName) ||
                string.IsNullOrWhiteSpace(request.LastName) ||
                string.IsNullOrWhiteSpace(request.Email) ||
                string.IsNullOrWhiteSpace(request.Password))
            {
                return BadRequest("All fields are required.");
            }

            var user = await _userService.RegisterAsync(
                request.FirstName,
                request.LastName,
                request.Email,
                request.Password);

            if (user == null)
            {
                return Conflict("A user with this email already exists.");
            }

            var token = GenerateJwtToken(user);
            var response = new AuthResponse
            {
                Token = token,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                AccountCreationDate = user.AccountCreationDate,
                LastLoginDate = user.LastLoginDate
            };

            return Ok(response);

        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Email) ||
                string.IsNullOrWhiteSpace(request.Password))
            {
                return BadRequest("Email and password are required.");
            }

            // ✅ Use AuthenticateAsync from the updated UserService
            var user = await _userService.AuthenticateAsync(request.Email, request.Password);

            if (user == null)
            {
                return Unauthorized("Invalid email or password.");
            }

            var token = GenerateJwtToken(user);

            var response = new AuthResponse
            {
                Token = token,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                AccountCreationDate = user.AccountCreationDate,
                LastLoginDate = user.LastLoginDate
            };

            return Ok(response);
        }

        // --------------------------------------------------
        // Helper: generate JWT using appsettings "Jwt" section
        // --------------------------------------------------
        private string GenerateJwtToken(User user)
        {
            var jwtSection = _configuration.GetSection("Jwt");
            var key = jwtSection["Key"];
            var issuer = jwtSection["Issuer"];
            var audience = jwtSection["Audience"];
            var expiresInMinutesString = jwtSection["ExpiresInMinutes"];

            var expiresInMinutes = string.IsNullOrWhiteSpace(expiresInMinutesString)
                ? 60
                : int.Parse(expiresInMinutesString);

            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key!));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
                new Claim(JwtRegisteredClaimNames.Email, user.Email),
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, $"{user.FirstName} {user.LastName}")
            };

            var token = new JwtSecurityToken(
                issuer: issuer,
                audience: audience,
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(expiresInMinutes),
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
