using System;
using System.Threading.Tasks;
using LlmApi.Data;
using LlmApi.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace LlmApi.Services
{
    public class UserService : IUserService
    {
        private readonly AppDbContext _db;
        private readonly PasswordHasher<User> _passwordHasher = new();

        public UserService(AppDbContext db)
        {
            _db = db;
        }

        public async Task<User?> RegisterAsync(string firstName, string lastName, string email, string password)
        {
            email = email.Trim().ToLowerInvariant();

            // Check if user exists
            if (await _db.Users.AnyAsync(u => u.Email == email))
                return null;

            var user = new User
            {
                FirstName = firstName.Trim(),
                LastName = lastName.Trim(),
                Email = email,
                AccountCreationDate = DateTime.UtcNow
            };

            user.PasswordHash = _passwordHasher.HashPassword(user, password);

            _db.Users.Add(user);
            await _db.SaveChangesAsync();

            return user;
        }


        public async Task<User?> AuthenticateAsync(string email, string password)
        {
            email = email.Trim().ToLowerInvariant();

            var user = await _db.Users.FirstOrDefaultAsync(u => u.Email == email);
            if (user == null)
                return null;

            var result = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, password);
            if (result == PasswordVerificationResult.Failed)
                return null;

            user.LastLoginDate = DateTime.UtcNow;
            await _db.SaveChangesAsync();

            return user;
        }

        public async Task<User?> GetByIdAsync(int id)
        {
            return await _db.Users.FindAsync(id);
        }
    }
}
