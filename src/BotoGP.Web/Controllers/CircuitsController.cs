using Microsoft.AspNetCore.Mvc;
using BotoGP.Domain.Repositories;
using BotoGP.Domain.Models;
using BotoGP.Domain.Presentation;
using BotoGP.Domain.Commands;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BotoGP.Web.Controllers;

[Route("api/[controller]")]
public class CircuitsController : Controller
{
    private static List<Circuit> cache;

    private readonly ICircuitRepository _circuitRepository;

    public CircuitsController(ICircuitRepository circuitRepository)
    {
        _circuitRepository = circuitRepository;
    }

    // GET: api/values
    [HttpGet]
    public IEnumerable<Circuit> Get()
    {
        if (cache == null)
        {
            var leMans = new Circuit
            {
                Id = new Guid("a2cb2c01-e7c3-4f23-8148-85d8e7eb726a"),
                Name = "Le Mans",
                Checkpoints = "[[75,20],[42,73],[86,62],[133,40]]",
                Map = new CircuitMap()
                {
                    CheckPoints = new List<CheckPoint>(new[]{
                        new CheckPoint(75, 20),
                        new CheckPoint(42, 73),
                        new CheckPoint(86, 62),
                        new CheckPoint(133, 40)
                    })
                }
            };

            var assen = new Circuit
            {
                Id = new Guid("f1c0ce30-23e6-41c2-a7c7-27a468382d73"),
                Name = "Assen TT",
                Checkpoints = "[[75,20],[12,16],[40,49],[93,52],[121,74],[122,36],[75,32]]",
                Map = new CircuitMap()
                {
                    CheckPoints = new List<CheckPoint>(new[]{
                        new CheckPoint(75, 20),
                        new CheckPoint(12, 16),
                        new CheckPoint(40, 49),
                        new CheckPoint(93, 52),
                        new CheckPoint(121, 74),
                        new CheckPoint(122, 36),
                        new CheckPoint(75,32 )
                    })
                }
            };

            cache = new List<Circuit>(new[] { leMans, assen });
        }

        return cache;
    }

    [HttpGet("{id}")]
    public Circuit Get(string id)
    {
        var c = Get();
        return c.FirstOrDefault(x => x.Id.ToString() == id);
    }

    // GET api/values/5
    [HttpGet("references")]
    public IEnumerable<CircuitReference> GetReferences()
    {
        return Get().Select(x => new CircuitReference
        {
            Id = x.Id.ToString(),
            Name = x.Name
        });
    }

    // POST api/values
    [HttpPost]
    public async Task Post([FromQuery] string name)
    {
        var c = new Circuit
        {
            Name = name
        };

        await _circuitRepository.StoreAsync(c);

        cache.Add(c);
    }

    [HttpPost("{id}")]
    public async Task<Circuit> Post(string id, [FromBody] UpdateCircuitDto model)
    {
        var c = Get(id) ?? new Circuit();

        if (!string.IsNullOrWhiteSpace(model?.Name))
            c.Name = model.Name;

        if (model?.CheckPoints != null)
        {
            c.Checkpoints = "[" + string.Join(",", model
                .CheckPoints
                .Select(p => $"[{p.x},{p.y}]")) + "]";

            c.Map.CheckPoints = model.CheckPoints;
        }

        if (model?.OnTrack != null)
        {
            c.Map.OnTrack = model.OnTrack;
        }

        if (model?.OffTrack != null)
        {
            c.Map.OffTrack = model.OffTrack;
        }

        await _circuitRepository.StoreAsync(c);

        return c;
    }
}