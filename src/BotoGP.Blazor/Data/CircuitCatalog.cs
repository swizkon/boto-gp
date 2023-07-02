namespace BotoGP.Blazor.Data;

public class CircuitCatalog
{

    public Task<CircuitInfo[]> GetCircuitsAsync(DateOnly startDate)
    {
        var files = Directory.GetFiles(AppContext.BaseDirectory, "*.jpg", SearchOption.AllDirectories);
        

        return Task.FromResult(files.Select(f => new CircuitInfo
        {
            Summary = Path.GetFileName(f),

        }).ToArray());
    }
}
    