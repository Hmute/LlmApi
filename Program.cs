using Microsoft.OpenApi.Models;             // Swagger
using LlmApi.Services;                      // ChatService, UserService
using LlmApi.Data;                          // AppDbContext
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// ✅ DEBUG: Check if environment variables are being read
Console.WriteLine("====================================");
Console.WriteLine("🔍 Configuration check (from Azure):");
Console.WriteLine("Model: " + builder.Configuration["AI:Model"]);
Console.WriteLine("Endpoint: " + builder.Configuration["AI:Endpoint"]);
Console.WriteLine("PAT exists: " + !string.IsNullOrEmpty(builder.Configuration["AI:PAT"]));
Console.WriteLine("====================================");




// -----------------------------
// Add services to the container
// -----------------------------
builder.Services.AddControllers();

// Add CORS for iOS/Android/Frontend
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

// SQLite DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
{
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection"));
});

// 🔐 JWT Bearer authentication
var jwtSection = builder.Configuration.GetSection("Jwt");
var jwtKey = jwtSection["Key"];

if (string.IsNullOrWhiteSpace(jwtKey))
{
    Console.WriteLine("⚠️ WARNING: Jwt:Key is missing in configuration!");
}

var signingKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey ?? "fallback-dev-key-change-me"));

builder.Services
    .AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateIssuerSigningKey = true,
            ValidateLifetime = true,

            ValidIssuer = jwtSection["Issuer"],
            ValidAudience = jwtSection["Audience"],
            IssuerSigningKey = signingKey,

            ClockSkew = TimeSpan.Zero // no extra time after expiry
        };
    });

// Swagger & API explorer
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Llm API",
        Version = "v1",
        Description = "A simple ASP.NET WebAPI that connects to GitHub Models using Semantic Kernel."
    });

    // Swagger JWT support
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Enter: **Bearer {your_jwt_token}**"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

// Register your ChatService as a singleton
builder.Services.AddSingleton<ChatService>();

// User service for register/login
builder.Services.AddScoped<IUserService, UserService>();

// -----------------------------
// Build the app
// -----------------------------
var app = builder.Build();


using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    dbContext.Database.EnsureCreated();
}
// -----------------------------
// Configure the HTTP request pipeline
// -----------------------------
app.UseSwagger();
app.UseSwaggerUI();

// Optional: Enforce HTTPS
app.UseHttpsRedirection();

// CORS must be before auth for preflight, etc.
app.UseCors("AllowAll");

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
