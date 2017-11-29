class NeuralNetwork
{
  public Matrix[] conversionArray;
  public Matrix[] biasArray;
  private int iV; //input Vars
  private int[] hL; // hidden
  private int oV; //output Vars
  public NeuralNetwork(int inputVars, int[] hidden, int outputVars)
  {
    //save some stuff we might need later just for convenience
    iV = inputVars; hL = hidden; oV = outputVars;
    //initiate the weights
    conversionArray = new Matrix[hidden.length + 1];
    conversionArray[0] = new Matrix(inputVars, hidden[0]);
    for (int i = 1; i < hidden.length; i++)
    {
      conversionArray[i] = new Matrix(hidden[i-1], hidden[i]);
    }
    conversionArray[hidden.length] = new Matrix(hidden[hidden.length - 1], outputVars);
    //initiate the biases
    biasArray = new Matrix[hidden.length + 1];
    for (int i = 0; i < hidden.length; i++)
    {
      biasArray[i] = new Matrix(1, hidden[i]);
    }
    biasArray[hidden.length] = new Matrix(1, outputVars);
  }
  public Matrix calculate(Matrix argMatrix)
  {
    Matrix inMatrix = argMatrix;//.deepCopy();
    for (int layer = 0; layer < conversionArray.length; layer++)
    {
      inMatrix = inMatrix.dotMultiply(conversionArray[layer]);
      inMatrix.addByColumns(biasArray[layer]);
      inMatrix.applyActivation();
    }
    return inMatrix;
  }
  public NeuralNetwork deepCopy()
  {
    NeuralNetwork newNN = new NeuralNetwork(iV, hL, oV);
    for (int i = 0; i < conversionArray.length; i++)
    {
      newNN.conversionArray[i] = conversionArray[i].deepCopy();
      newNN.biasArray[i] = biasArray[i].deepCopy();
    }
    return newNN;
  }
  public void mutate()
  {
    if (mainRng.nextInt(2) == 0)
    {
      //mutate (change subtly) conversion array
      Matrix tgt = conversionArray[mainRng.nextInt(conversionArray.length)];
      tgt.matrix[mainRng.nextInt(tgt.rows)][mainRng.nextInt(tgt.cols)] += (mainRng.nextInt(21)-10)/10;
    }
  }
  public void show()
  {
    for (int i = 0; i < conversionArray.length; i++)
    {
      Matrix conA = conversionArray[i];
      for (int a = 0; a < conA.rows; a++)//iterate over inputs
      {
        for (int b = 0; b < conA.cols; b++)//iterate over next layer
        {
          float weight = conA.matrix[a][b];
          //weight to colour
          int g;
          int r;
          if (weight > 0) {
            g = 255;
            r = (int)(255 * (1 - weight));
          } else {
            r = 255;
            g = (int)(255 * (1 + weight));
          }
          stroke(r, g, 0);
          int offY = 170;
          int offX = 620;
          line(offX+i*50, offY+a*50, offX+50+i*50, offY+b*50);
        }
      }
    }
  }
}