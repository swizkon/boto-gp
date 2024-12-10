using Serilog;

namespace BotoGP.Web
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                // .UseContentRoot(Path.Combine(Directory.GetCurrentDirectory(), "frontend", "public"))
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    //webBuilder.UseUrls()
                    webBuilder.UseSerilog();
                    webBuilder.UseStartup<Startup>();
                    webBuilder.UseStaticWebAssets();
                });
    }
}
    