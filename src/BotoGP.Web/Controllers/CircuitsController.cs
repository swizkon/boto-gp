using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BotoGP.Domain.Commands;
using BotoGP.Domain.Models;
using BotoGP.Domain.Presentation;
using BotoGP.Domain.Repositories;
using Microsoft.AspNetCore.Mvc; // using BotoGP.stateserver.Repos;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BotoGP.Web.Controllers
{
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
        public async Task<IEnumerable<Circuit>> Get()
        {
            if (cache == null)
            {
                var circuits = await _circuitRepository.ReadAllAsync();
                cache = circuits.ToList();
            }

            return cache;
        }

        [HttpGet("{id}")]
        public async Task<Circuit> Get(string id)
        {
            var c = await Get();
            return c.FirstOrDefault(x => x.Id.ToString() == id);
        }

        // GET api/values/5
        [HttpGet("references")]
        public async Task<IEnumerable<CircuitReference>> GetReferences()
        {
            var c = await Get();
            return c.Select(x => new CircuitReference{
                    Id = x.Id.ToString(),
                    Name = x.Name
            });
        }

        // POST api/values
        [HttpPost]
        public async Task Post([FromQuery]string name)
        {
            var c = new Circuit
            {
                Name = name
            };

            await _circuitRepository.StoreAsync(c);

            cache.Add(c);
        }

        [HttpPost("{id}")]
        public async Task<Circuit> Post(string id, [FromBody]UpdateCircuitDto model)
        {
            var c = (await Get(id)) ?? new Circuit();
            
            if(!string.IsNullOrWhiteSpace(model?.Name) )
                c.Name = model.Name;
            
            if(model?.CheckPoints != null)
            {
                c.Checkpoints = "[" + string.Join(",", model
                                .CheckPoints
                                .Select(p => $"[{p.x},{p.y}]")) + "]";

                c.Map.CheckPoints = model.CheckPoints;
            }
            
            if(model?.OnTrack != null)
            {
                c.Map.OnTrack = model.OnTrack;
            }
            
            if(model?.OffTrack != null)
            {
                c.Map.OffTrack = model.OffTrack;
            }

            await _circuitRepository.StoreAsync(c);

            return c;
        }
    }
}
