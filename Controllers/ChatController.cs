using Microsoft.AspNetCore.Mvc;
using LlmApi.Services;
using Microsoft.AspNetCore.Authorization;

namespace LlmApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]

public class ChatController : ControllerBase
{
    private readonly ChatService _chatService;

    public ChatController(ChatService chatService)
    {
        _chatService = chatService;
    }

    [HttpPost]
    public async Task<IActionResult> Post([FromBody] ChatRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Prompt))
            return BadRequest("Prompt cannot be empty.");

        var reply = await _chatService.GetReplyAsync(request.Prompt);
        return Ok(new { reply });
    }
}

public class ChatRequest
{
    public string Prompt { get; set; } = string.Empty;
}
