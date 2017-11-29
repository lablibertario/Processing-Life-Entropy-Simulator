class Agent
{
  public NeuralNetwork brain;
  public float posX;
  public float posY;
  public float hdg;
  public float food;
  public float lifeTime;
  public String name;
  public Agent(String _name)
  {
    name = _name;
    int[] hidden = new int[mainRng.nextInt(3) + 1];
    for (int l = 0; l < hidden.length; l++)
    {
      hidden[l] = mainRng.nextInt(5) + 3;
    }
    brain = new NeuralNetwork(7, hidden, 2);
    posX = mainRng.nextInt(600);
    posY = mainRng.nextInt(600);
    food = 1.0f;
    hdg = 0;
    lifeTime = 0;
  }
  public Agent reproduce()//fancy way for saying deepCopy - that sounds dumb!
  {
    Agent newAgent = new Agent(name + "+");
    newAgent.brain = brain.deepCopy();
    newAgent.posX = posX;
    newAgent.posY = posY;
    newAgent.hdg = hdg + 180;
    return newAgent;
  }
  public void show()
  {
    ellipse(posX, posY, 10, 10);
  }
  public boolean live()
  {
    lifeTime += 0.0001;
    //determine the location of the agent
    int gridX = (int)posX/12;
    int gridY = (int)posY/12;
    //determine the location of the agent's senses. as of now...
    //1 unit ahead, 1 unit 45 deg left, 1 unit 45 deg right, directly underneath
    //1 unit ahead. 0 degrees is defined as straight to the right.
    Matrix inputs = new Matrix(1,7);
    for (int i = 0; i < 6; i++)
    {
      float dx;
      float dy;
      switch (i)
      {
        case 0:
          dx = 0;
          dy = 0;
          break;
        case 1:
          dx = (float)Math.cos(Math.toRadians(hdg));
          dy = (float)Math.sin(Math.toRadians(hdg));
          break;
        case 2:
          dx = (float)Math.cos(Math.toRadians(hdg + 45));
          dy = (float)Math.sin(Math.toRadians(hdg + 45));
          break;
        case 3:
          dx = (float)Math.cos(Math.toRadians(hdg - 45));
          dy = (float)Math.sin(Math.toRadians(hdg - 45));
          break;
        case 4:
          dx = (float)Math.cos(Math.toRadians(hdg + 90));
          dy = (float)Math.sin(Math.toRadians(hdg + 90));
          break;
        default:
          dx = (float)Math.cos(Math.toRadians(hdg - 90));
          dy = (float)Math.sin(Math.toRadians(hdg - 90));
          break;
      }
      dx *= 12;
      dy *= 12;
      //ellipse(dx + posX, dy + posY, 6 ,6);
      fill(255,0,0);
      int sensX = (int)(dx + posX)/12;
      int sensY = (int)(dy + posY)/12;
      if (sensX >= 0 && sensX < 50 && sensY >= 0 && sensY < 50) {
        inputs.matrix[0][i] = WORLD[sensX][sensY].food;
      } else {
        inputs.matrix[0][i] = 0;
      }
    }
    inputs.matrix[0][6] = food;
    //inputs.show();
    //we now have values for the input matrix. time to get the output matrix.
    Matrix action = brain.calculate(inputs);
    //2 numbers given. first one shows movement, second one shows steering
    //food -= (Math.abs(action.matrix[0][1]) + Math.abs(action.matrix[0][0])) * .05;
    float moveDX = (float)Math.cos(Math.toRadians(hdg)) * 10 * action.matrix[0][0];
    float moveDY = (float)Math.sin(Math.toRadians(hdg)) * 10 * action.matrix[0][0];
    posX += moveDX;
    posY += moveDY;
    if (posX >= 600) {posX = 599;}
    if (posX < 0) {posX = 0;}
    if (posY >= 600) {posY = 599;}
    if (posY < 0) {posY = 0;}
    hdg += action.matrix[0][1] * 5;
    food -= 0.03;
    if (food < 0.97 && WORLD[gridX][gridY].food >= 0.03)
    {
      WORLD[gridX][gridY].food -= 0.05;
      food += 0.05;
    }
    if (food <= 0)
    {
      return false;
    }
    if (WORLD[gridX][gridY].tileType == TileType.Water) {food -= 0.2;}
    return true;
  }
  public void showBrain()
  {
    brain.show();
  }
}