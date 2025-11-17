using LlmApi.Models;

namespace LlmApi.Services
{
    public interface IUserService
    {
        Task<User?> RegisterAsync(string firstName, string lastName, string email, string password);
        Task<User?> AuthenticateAsync(string email, string password);
    }

}
