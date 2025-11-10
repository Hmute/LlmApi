using LlmApi.Services;              // your ChatService
using Microsoft.OpenApi.Models;     // for Swagger

var builder = WebApplication.CreateBuilder(args);

// -----------------------------
// Add services to the container
// -----------------------------
builder.Services.AddControllers();

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
});

// Register your ChatService as a singleton
builder.Services.AddSingleton<ChatService>();

// -----------------------------
// Build the app
// -----------------------------
var app = builder.Build();

// -----------------------------
// Configure the HTTP request pipeline
// -----------------------------
app.UseSwagger();
app.UseSwaggerUI();

// Optional: Enforce HTTPS
app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
