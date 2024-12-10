using BotoGP.Domain.Models;

namespace BotoGP.Domain.Repositories
{
    public interface ICircuitRepository
    {
        Task<IEnumerable<Circuit>> ReadAllAsync();

        Task<Circuit> ReadAsync(string id);

        Task StoreAsync(Circuit circuit);
    }
}