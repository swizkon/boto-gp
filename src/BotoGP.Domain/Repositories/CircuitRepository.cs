

using System;
using BotoGP.Domain.Models;
using BotoGP.Domain.Repositories;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;

namespace BotoGP.Domain.Services
{
    public class CircuitRepository : ICircuitRepository
    {
        IConfiguration _configuration;

        ILogger _logger;

        private static IEnumerable<Circuit> circuits = new List<Circuit>();

        public CircuitRepository(IConfiguration configuration, ILogger<CircuitRepository> logger)
        {
            _configuration = configuration;
            _logger = logger;
            
            _logger.LogInformation("StorageConnectionString");
            _logger.LogInformation(_configuration["StorageConnectionString"]);


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

            var assen = new Circuit()
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

            circuits = circuits.Append(leMans).Append(assen).ToList();
        }

        public async Task<IEnumerable<Circuit>> ReadAllAsync()
            => await Task.FromResult(circuits);

        public async Task<Circuit> ReadAsync(string id)
            => (await ReadAllAsync()).FirstOrDefault(x => x.Id.ToString() == id);

        public async Task StoreAsync(Circuit circuit)
        {
            circuits = circuits.Where(x => x.Id != circuit.Id).Append(circuit);

            await Task.FromResult(true);
        }
    }
}
