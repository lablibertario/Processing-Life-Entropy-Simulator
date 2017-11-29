import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.nio.file.Paths;

void getWorldMap()
{
  boolean deploy = false;
  String mapFile = "C:\\Users\\yanglu\\Documents\\Processing\\Projects\\Life_Simulation\\main\\nazi.png";
  String depFile = Paths.get("maps\\map.png").toAbsolutePath().normalize().toString();
  BufferedImage img;
  try {
    if (!deploy)
    {img = ImageIO.read(new File(mapFile));}
    else {img = ImageIO.read(new File(depFile));}
  } catch (IOException e) {
    println(e);
    println("Error opening image.");
    return;
  }
  for (int x = 0; x < 50; x++)
  {
    for (int y = 0; y < 50; y++)
    {
      //-1 = land, -16777216 = water
      if (img.getRGB(x, y) == -1)
      {
        WORLD[x][y] = new Tile(TileType.Land);
      }
      else
      {
        WORLD[x][y] = new Tile(TileType.Water);
      }
    }
  }
}