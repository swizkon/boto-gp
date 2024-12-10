namespace BotoGP.Domain.Models
{
    public class CircuitMap
    {
		public List<CheckPoint> CheckPoints {get;set;} = new List<CheckPoint>();

        public List<CheckPoint> OnTrack { get; set; } = new List<CheckPoint>();

        public List<CheckPoint> OffTrack { get; set; } = new List<CheckPoint>();
    }
}