using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Threading.Tasks;
using BotoGP.Domain.Repositories;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BotoGP.Web.Controllers
{
    [Route("api/[controller]")]
    public class HeatMapsController : Controller
    {
        private static ConcurrentDictionary<string, string> cache
            = new ConcurrentDictionary<string, string>();


        private readonly ICircuitRepository _circuitRepository;

        public HeatMapsController(ICircuitRepository circuitRepository)
        {
            _circuitRepository = circuitRepository;
        }

        [HttpGet("{id}/tileinfo")]
        public async Task<string> GetTileInfo(string id, [FromQuery]int x, [FromQuery]int y)
        {
            return await TileInfo(id, x, y);
        }

        private async Task<string> TileInfo(string id, int x, int y)
        {
            var key = $"{id}/{x}:{y}";

            return cache.GetOrAdd(key, await LoadTileInfo(id, x, y));
        }

        private async Task<string> LoadTileInfo(string id, int x, int y)
        {
            if (x < 0 || y < 0)
                return "Miss";

            var heat = await Heat(id);

            return FindHeat(heat, x, y);
        }

        private string FindHeat(IDictionary<string, int> heat, int x, int y, int retries = 0)
        {
            if (x < 0)
                return "Miss Out of bound after " + retries;

            var key = buildKey(x,y);

            if (heat.ContainsKey(key))
                return heat[key] == 1 ? "Hit in " + retries : "Miss in " + retries;

            return FindHeat(heat, x - 1, y, retries + 1);
        }

        private async Task<IDictionary<string, int>> Heat(string id)
        {
            var circuit = await new CircuitsController(_circuitRepository).Get(id);

            var heat = new Dictionary<string, int>();

            circuit.Map.OffTrack.ForEach(o =>
            {
                heat[buildKey(o.x,o.y)] = 0;
            });
            circuit.Map.OnTrack.ForEach(o =>
            {
                heat[buildKey(o.x,o.y)] = 1;
            });

            return heat;
        }

        private string buildKey(int x, int y)
        {
            return "x:" + x + ",y:" + y;
        }
    }
}
