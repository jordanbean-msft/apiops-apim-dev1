using System.Collections.Generic;
using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Enums;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;

namespace src
{
  public class dev1_api
  {
    private readonly ILogger _logger;

    public dev1_api(ILoggerFactory loggerFactory)
    {
      _logger = loggerFactory.CreateLogger<dev1_api>();
    }

    [OpenApiOperation(operationId: "greeting", tags: new[] { "greeting" }, Summary = "Greetings", Description = "This shows a welcome message.", Visibility = OpenApiVisibilityType.Important)]
    [OpenApiSecurity("function_key", SecuritySchemeType.ApiKey, Name = "code", In = OpenApiSecurityLocationType.Query)]
    [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "text/plain", bodyType: typeof(string), Summary = "The response", Description = "This returns the response")]

    [Function("dev1-api")]
    public HttpResponseData Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequestData req)
    {
      _logger.LogInformation("C# HTTP trigger function processed a request.");

      var response = req.CreateResponse(HttpStatusCode.OK);
      response.Headers.Add("Content-Type", "text/plain; charset=utf-8");

      response.WriteString("dev1-api");

      return response;
    }
  }
}
