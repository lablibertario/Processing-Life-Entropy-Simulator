import java.util.Random;

public static Random mainRng = new Random();
Tile[][] WORLD = new Tile[50][50];
ArrayList<Agent> AgentList = new ArrayList<Agent>();
float recordAgent = 0;
int bestAgent = 0;
float bestAgentVal = 0;
String bestName = "";
NameGen nameGenerator = new NameGen();
int deaths = 0;
//boolean recordShown;

void setup() {
  //println(Math.cos(3.14159 * 2));
  //LOAD agents
  for (int i = 0; i < 30; i++)
  {
    AgentList.add(new Agent(nameGenerator.next()));
  }
  //LOAD the world map (from image)
  getWorldMap(); //writes into global var WORLD
  size(1200, 600);
}

void draw() {
  stroke(0);
  background(0);
  fill(255);
  textSize(18);
  text("Record lifetime: " + String.valueOf(recordAgent), 620, 30);
  text("Current best lifetime: " + Float.toString(bestAgentVal), 620, 60);
  text("Record creature name: " + bestName, 620, 90);
  text("Creatures \"made\": " + Integer.toString(nameGenerator.count), 620, 120);
  text("Neural network representation of best performing creature's brain: ", 620, 150);
  //rect(12 * 49, 12 * 49, 12, 12);
  bestAgentVal = 0;
  //recordShown = false;
  for (int x = 0; x < 50; x++)
  {
    for (int y = 0; y < 50; y++)
    {
      int[] sqCol = WORLD[x][y].getColour();
      fill(sqCol[0], sqCol[1], sqCol[2]);
      rect(12*x, 12*y, 12, 12);
      float[] surroundingFertility = new float[4];
      if (x > 0)  {surroundingFertility[0] = WORLD[x-1][y].fertility;}
      if (x < 49) {surroundingFertility[1] = WORLD[x+1][y].fertility;}
      if (y > 0)  {surroundingFertility[2] = WORLD[x][y-1].fertility;}
      if (y < 49) {surroundingFertility[3] = WORLD[x][y+1].fertility;}
      WORLD[x][y].updateVars(surroundingFertility, x, y);
    }
  }
  fill(255,0,0);
  ArrayList<Integer> killList = new ArrayList<Integer>();
  for (int i = 0; i < AgentList.size(); i++)
  {
    Agent agent = AgentList.get(i);
    if (agent.live())
    {
      stroke(0);
      agent.show();
      if (agent.lifeTime > recordAgent)
      {
        recordAgent = agent.lifeTime;
        bestName = agent.name;
        fill(0, 255, 255);
        agent.show();
        fill(255, 0, 0);
        //agent.showBrain();
        //recordShown = true;
      }
      if (agent.lifeTime > bestAgentVal) { bestAgent = i; bestAgentVal = agent.lifeTime; }
    } else {
      killList.add(i);
    }
  }
  //AgentList.get(mainRng.nextInt(AgentList.size())).showBrain();
  AgentList.get(bestAgent).showBrain();
  for (int i = killList.size() - 1; i >= 0; i--)
  {
    deaths++;
    AgentList.remove(killList.get(i) - i);//array will shrink with every one killed, and killList is in order.
    if (AgentList.size() < 30) {AgentList.add(new Agent(nameGenerator.next()));}
  }
  //println(AgentList.size());
}