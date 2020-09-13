using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using BotoGP.Domain.Models;
using BotoGP.Web.Hubs;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;

namespace BotoGP.Web.Controllers
{
    [Route("api/[controller]/{raceid}")]
    public class RaceStateController : Controller
    {
        private readonly IHubContext<RaceHub> _hubContext;

        private static ConcurrentDictionary<string, List<RaceState>> states
                    = new ConcurrentDictionary<string, List<RaceState>>();

        public RaceStateController(IHubContext<RaceHub> hubContext)
        {
            _hubContext = hubContext;
        }

        [HttpGet]
        public IEnumerable<RaceState> Get()
        {
            var race = states.GetValueOrDefault(RaceId);
            return race;
        }

        [HttpGet("{id}")]
        public RaceState Get(string id)
        {
            var race = states.GetValueOrDefault(RaceId);
            return race?.FirstOrDefault(x => x.RiderId == id);
        }

        [HttpPost("{id}")]
        public void Post(string id,
                         [FromQuery]string key,
                         [FromQuery]int x,
                         [FromQuery]int y)
        {
            var racer = Get(id);
            if (racer != null && racer.RiderKey == key)
            {
                racer.ForceX += x;
                racer.ForceY += y;
                racer.PosX += racer.ForceX;
                racer.PosY += racer.ForceY;

                Update(racer.RiderId, racer.RiderKey, racer);
            }
			
			_hubContext.Clients.All.SendAsync("Move", "racer-move", x, y);
        }

        [HttpPut("{id}")]
        public void Put(string id, [FromQuery]string key)
        {
            var state = new RaceState { RiderId = id, RiderKey = key };
            Update(id, key, state);
        }

        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }

        private void Update(string id, string key, RaceState newState)
        {
            states.AddOrUpdate(RaceId
                               , new List<RaceState>() { newState }
                            , (k, list) =>
                            {
                                list.RemoveAll(x => x.RiderId == id && x.RiderKey == key);
                                list.Add(newState);
                                return list;
                            });
        }


        public string RaceId => (string)RouteData.Values.GetValueOrDefault(nameof(RaceId));

        //private string RaceId()
        //{
        //    return (string)RouteData.Values.GetValueOrDefault("raceid");
        //}
    }
}
