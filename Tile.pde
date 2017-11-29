enum TileType
{
  Water,
  Land,
}

class Tile
{
  public float fertility;
  public float food;
  public TileType tileType;
  
  public Tile(TileType tT)
  {
    fertility = 0.5f;
    food = 0.2f;
    tileType = tT;
    //updateVars(new float[] {.5,.5,.5,.5});
  }
  public void updateVars(float[] sf, int x, int y)
  {
    //fertility -= 0.01f;
    fertility -= food*0.02;
    food -= 0.01f;
    if (tileType == TileType.Water)
    {
      fertility = 1.0f;
      food = -1.0f;
      return;
    }
    food += fertility / 40.0f;
    for (int i = 0; i < 4; i++)//compensate for surrounding block's fertility
    {
      float gain = 0.12 * sf[i];
      fertility += gain;
      if (gain != 0)
      {
        switch (i)
        {
          case 0:
            WORLD[x-1][y].fertility -= gain;
            break;
          case 1:
            WORLD[x+1][y].fertility -= gain;
            break;
          case 2:
            WORLD[x][y-1].fertility -= gain;
            break;
          case 3:
            WORLD[x][y+1].fertility -= gain;
            break;
        }
      }
    }
    if (fertility < 0) {fertility = 0;}
    if (food < 0) {food = 0;}
    if (fertility > 1) {fertility = 1;}
    if (food > 1) {food = 1;}
  }
  public int[] getColour()
  {
    if (tileType == TileType.Water)
    {
      return new int[] {0, 0, 255};
    }
    int[] colours = new int[3];
    colours[1] = 255;
    int rbColour = Math.round(255 * (1.0f - food));
    colours[0] = rbColour;
    colours[2] = rbColour;
    return colours;
  }
}