namespace BotoGP.Domain.Models
{
    public class CheckPoint
    {
        public CheckPoint()
        {
        }

        public CheckPoint(int x, int y)
        {
            this.x = x;
            this.y = y;
        }

        public int x { get; set; }

        public int y { get; set; }
    }
}