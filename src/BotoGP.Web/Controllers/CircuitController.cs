using System.Linq;
using System.Threading.Tasks;
using BotoGP.Domain.Models;
using BotoGP.Domain.Repositories;
using Microsoft.AspNetCore.Mvc; //using BotoGP.stateserver.Repos;

namespace BotoGP.Web.Controllers
{
    [Route("graphics/[controller]")]
    public class CircuitController : Controller
    {
        private readonly ICircuitRepository _circuitRepository;

        public CircuitController(ICircuitRepository circuitRepository)
        {
            _circuitRepository = circuitRepository;
        }

        [HttpGet("{id}/heatmap")]
        public async Task<CircuitMap> GetHeatMap(string id)
        {
            var c =await new CircuitsController(_circuitRepository).Get(id);
            return c?.Map;
        }

        // GET api/values/5
        [HttpGet("{id}/svg")]
        public async Task< FileContentResult> Svg(string id, int scale = 1)
        {
            string path = "";
            var c = await new CircuitsController(_circuitRepository).Get(id);
            if(c != null)
            {
                path = "M" + string.Join(" L", c.Map.CheckPoints.Select(p => $"{p.x * scale},{p.y * scale}")) + " z";
            }

            var data = $@"<?xml version=""1.0"" encoding=""UTF-8"" standalone=""no""?>
<!DOCTYPE svg PUBLIC ""-//W3C//DTD SVG 1.1//EN"" ""http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"">
<svg xmlns=""http://www.w3.org/2000/svg"" width=""{150 * scale}px"" height=""{100 * scale}px"" viewBox=""0 0 {150 * scale} {100 * scale}"" preserveAspectRatio=""xMidYMid meet"">
    <title>Circuit</title>
    <g id=""main"">
        <path stroke=""#666666"" stroke-linecap=""round"" stroke-linejoin=""round"" stroke-width=""{20 * scale}"" fill=""transparent"" d=""{path}"" />
        <path stroke=""#cccccc"" stroke-linecap=""round"" stroke-linejoin=""round"" stroke-width=""{15 * scale}"" fill=""transparent"" d=""{path}"" />
    </g>
</svg>";
            return new FileContentResult(System.Text.Encoding.UTF8.GetBytes(data), "image/svg+xml");
        }
    }
}
