using System.Threading.Tasks;
using Microsoft.AspNetCore.SignalR;

namespace BotoGP.Web.Hubs
{
    public class RaceHub : Hub
    {
        public Task Send(string message)
        {
            return Clients.All.SendAsync("Send", message);
        }

        public Task NextMove(string racer, int move)
        {
            return RaceStateChange(racer, 0, 0, move, move);
        }

        public Task RaceStateChange(
            string racer, 
            int x, 
            int y, 
            int verticalVelocity, 
            int horizontalVelocity)
        {
            return Clients.All.SendAsync("RaceStateChange", racer, x, y, verticalVelocity, horizontalVelocity);
        }

        public Task Move(string racer, int x, int y)
        {
            return Clients.All.SendAsync("Move", racer, x, y);
        }

        public Task CrashInfo(string racer)
        {
            return Clients.All.SendAsync("Crash", racer);
        }

        public void JoinTour(string racer, string tour)
        {
            Groups.AddToGroupAsync(Context.ConnectionId, tour);

            RaceStateChange(racer, 0,0,0,0);
        }

        public Task LeaveRace(string raceId)
        {
            return Groups.RemoveFromGroupAsync(Context.ConnectionId, raceId);
        }

    }
}