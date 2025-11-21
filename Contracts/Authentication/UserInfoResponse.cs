using System;

namespace LlmApi.Contracts.Authentication
{
    public class UserInfoResponse
    {
        public int Id { get; set; }
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public DateTime AccountCreationDate { get; set; }
        public DateTime? LastLoginDate { get; set; }
    }
}
