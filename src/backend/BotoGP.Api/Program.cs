using Serilog;

namespace BotoGP.Api;

public class Program
{
    public static void Main(string[] args)
    {
        CreateHostBuilder(args).Build().Run();
    }

    private static IHostBuilder CreateHostBuilder(string[] args) =>
        Host.CreateDefaultBuilder(args)
            .ConfigureWebHostDefaults(webBuilder =>
            {
                //webBuilder.UseUrls()
                webBuilder.UseSerilog();
                webBuilder.UseStartup<Startup>();
                webBuilder.UseStaticWebAssets();
            });
}