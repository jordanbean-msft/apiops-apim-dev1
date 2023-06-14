using Microsoft.Azure.Functions.Worker.Extensions.OpenApi.Extensions;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Abstractions;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Configurations;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Enums;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;

var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults()
                .ConfigureServices(services =>
                {
                  services.AddSingleton<IOpenApiConfigurationOptions>(_ =>
                          {
                            var options = new OpenApiConfigurationOptions()
                            {
                              Info = new OpenApiInfo()
                              {
                                Version = DefaultOpenApiConfigurationOptions.GetOpenApiDocVersion(),
                                Title = "dev1-api",
                              },
                              Servers = DefaultOpenApiConfigurationOptions.GetHostNames(),
                              OpenApiVersion = OpenApiVersionType.V3,
                              IncludeRequestingHostName = DefaultOpenApiConfigurationOptions.IsFunctionsRuntimeEnvironmentDevelopment()
                            };
                            return options;
                          });
                })
    .Build();

host.Run();
