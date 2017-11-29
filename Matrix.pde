import java.lang.Math;

public class SizeError extends RuntimeException {
  public SizeError(String message)
  {
    super(message);
  }
}

class Matrix
{
  public float[][] matrix;
  public int rows;
  public int cols;
  public Matrix(int r, int c)
  {
    rows = r;
    cols = c;
    matrix = new float[r][c];
    randomize();
  }
  public Matrix(int r, int c, boolean rand)
  {
    rows = r;
    cols = c;
    matrix = new float[r][c];
    if (!rand)
    {
      for (int row = 0; row < rows; row++)
      {
        for (int col = 0; col < cols; col++)
        {
          matrix[row][col] = 0.0f;
        }
      }
    }
    else
    {
      randomize();
    }
  }
  public void randomize()
  {
    for (int row = 0; row < rows; row++)
    {
      for (int col = 0; col < cols; col++)
      {
        matrix[row][col] = (mainRng.nextInt(21) - 10) / 10.0f;
      }
    }
  }
  public void zero()
  {
    for (int row = 0; row < rows; row++)
    {
      for (int col = 0; col < cols; col++)
      {
        matrix[row][col] = 0;
      }
    }
  }
  public Matrix dotMultiply(Matrix other)
  {
    if (cols != other.rows)
    {
      throw new SizeError("Matrix dot-multiply size mismatch.");
    }
    Matrix newMatrix = new Matrix(rows, other.cols);
    newMatrix.zero();
    for (int matrixTwoCol = 0; matrixTwoCol < other.cols; matrixTwoCol++)
    {
      for (int matrixOneRow = 0; matrixOneRow < rows; matrixOneRow++)
      {
        for (int matrixOneCol = 0; matrixOneCol < cols; matrixOneCol++)
        {
          newMatrix.matrix[matrixOneRow][matrixTwoCol] += matrix[matrixOneRow][matrixOneCol] * other.matrix[matrixOneCol][matrixTwoCol];
        }
      }
    }
    return newMatrix;
  }
  public void addByColumns(Matrix other)
  {
    if (other.rows != 1)
    {
      throw new SizeError("Other matrix must be one row only.");
    }
    for (int row = 0; row < rows; row++)
    {
      for (int col = 0; col < cols; col++)
      {
        matrix[row][col] += other.matrix[0][col];
      }
    }
  }
  public void applyActivation()
  {
    for (int row = 0; row < rows; row++)
    {
      for (int col = 0; col < cols; col++)
      {
        matrix[row][col] = (float)Math.tanh(matrix[row][col]);
      }
    }
  }
  public Matrix deepCopy()
  {
    Matrix newMatrix = new Matrix(rows, cols);
    for (int row = 0; row < rows; row++)
    {
      for (int col = 0; col < cols; col++)
      {
        newMatrix.matrix[row][col] = matrix[row][col];
      }
    }
    return newMatrix;
  }
  public void show()
  {
    for (int row = 0; row < rows; row++)
    {
      for (int col = 0; col < cols; col++)
      {
        print(matrix[row][col] + "\t");
      }
      println();
    }
    println();
  }
}