using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.ChatCompletion;
using OpenAI;
using System.ClientModel;
using System.Text;
using Microsoft.Extensions.Configuration;

namespace LlmApi.Services;

public class ChatService
{
    private readonly IChatCompletionService _chatCompletion;
    private readonly Kernel _kernel;

    public ChatService(IConfiguration config)
    {
        var modelId = config["AI:Model"]!;
        var uri = config["AI:Endpoint"]!;
        var githubPAT = config["AI:PAT"]!;

        if (string.IsNullOrWhiteSpace(modelId) ||
    string.IsNullOrWhiteSpace(uri) ||
    string.IsNullOrWhiteSpace(githubPAT))
        {
            throw new InvalidOperationException(
                "Missing required AI configuration. Check Azure Application Settings.");
        }

        Console.WriteLine($"[DEBUG] Using endpoint: {uri}");
        Console.WriteLine($"[DEBUG] Using model: {modelId}");
        Console.WriteLine($"[DEBUG] Token length: {githubPAT?.Length}");

        var client = new OpenAIClient(
            new ApiKeyCredential(githubPAT.Trim()),
            new OpenAIClientOptions
            {
                Endpoint = new Uri(uri),
            });

        var builder = Kernel.CreateBuilder();
        builder.AddOpenAIChatCompletion(modelId, client);
        _kernel = builder.Build();
        _chatCompletion = _kernel.GetRequiredService<IChatCompletionService>();
    }

    public async Task<string> GetReplyAsync(string userPrompt)
    {
        var chat = new ChatHistory(@"
            You are an AI assistant that helps people find information. 
            The response must be brief and should not exceed one paragraph.
            If you do not know the answer then simply say 'I do not know the answer'.");

        chat.AddUserMessage(userPrompt);

        var sb = new StringBuilder();

        await foreach (var msg in _chatCompletion.GetStreamingChatMessageContentsAsync(chat, kernel: _kernel))
        {
            sb.Append(msg.Content);
        }

        return sb.ToString();
    }
}
