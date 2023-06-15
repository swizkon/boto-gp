namespace BotoGP.Blazor.Data;

public class WeatherForecastService
{

    public Task<WeatherForecast[]> GetForecastAsync(DateOnly startDate)
    {
        var files = Directory.GetFiles(AppContext.BaseDirectory, "*.jpg", SearchOption.AllDirectories);
        

        return Task.FromResult(files.Select(f => new WeatherForecast
        {
            Summary = Path.GetFileName(f),

        }).ToArray());
    }
}
    