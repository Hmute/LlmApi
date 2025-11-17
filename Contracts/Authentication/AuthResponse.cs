namespace LlmApi.Contracts.Authentication
{
    public class AuthResponse
    {
        public string Token { get; set; } = string.Empty;

        public string FirstName { get; set; } = string.Empty;
        public string LastName  { get; set; } = string.Empty;
        public string Email     { get; set; } = string.Empty;

        public DateTime AccountCreationDate { get; set; }
        public DateTime? LastLoginDate { get; set; }
    }
}
