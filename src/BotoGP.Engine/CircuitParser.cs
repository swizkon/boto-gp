using System.Drawing;

namespace BotoGP.Engine
{
    public class CircuitParser
    {
        public IEnumerable<Point> GetBoundariesFromImage(string imagePath)
        {
            var fs = Image.FromFile(imagePath);
            var resized = new Bitmap(fs, fs.Size.Width, fs.Size.Height);

            for (var x = 0; x < fs.Size.Width; x++)
            for (var y = 0; y < fs.Size.Height; y++)
            {
                var c = resized.GetPixel(x, y);

                if (c.G > 50 || c.B > 50)
                    continue;

                if (c.R < 150)
                    continue;

                yield return new Point(x, y);
            }
        }

        public IEnumerable<Point> GetSignificantPoints(IEnumerable<Point> input)
        {
            var h = new HashSet<Point>();
            
            var selection = input.Where(i => i.X % 2 == 0 && i.Y % 2 == 0);

            foreach (var p in selection)
            {
                if (!h.Contains(p))
                {
                    h.Add(p);
                    for (var i = 0; i < 20; i++)
                    {
                        h.Add(new Point(x: p.X + i, y: p.Y));
                        h.Add(new Point(x: p.X, y: p.Y + i));
                        h.Add(new Point(x: p.X + i, y: p.Y + i));
                        h.Add(new Point(x: p.X - i, y: p.Y - i));
                    }
                    yield return p;
                }
            }
        }
    }
}