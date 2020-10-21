class Table {
  int cols;
  int rows;
  float cellW;
  float cellH;

  public Table(int cols, int rows, float cellW, float cellH) {
    this.cols = cols;
    this.rows = rows;
    this.cellW = cellW;
    this.cellH = cellH;
  }

  public void draw() {
    for (int row = 0, cell = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        drawCell(col, row, cell);
        cell++;
      }
    }
  }

  private void drawCell(int col, int row, int cell) {
    PVector cellPosition = calcCellPosition(col, row);

    pushMatrix();
    translate(cellPosition.x, cellPosition.y);
    if (isPrime(cell))
      drawPrimeCell();
    else
      drawCompositeCell();
    popMatrix();
  }

  private void drawPrimeCell() {
    fill(112, 82, 224);
    ellipse(0, 0, cellW, cellH);
  }

  private void drawCompositeCell() {
    fill(230, 96, 165);
    rect(-cellW / 2.0, -cellH / 2.0, cellW, cellH);
  }

  private PVector calcCellPosition(int col, int row) {
    float cellX = cellW / 2.0 + cellW * col;
    float cellY = cellH / 2.0 + cellH * row;

    return new PVector(cellX, cellY);
  }

  private boolean isPrime(int val) {
    if (val < 2) return false;

    boolean isPrime = true;

    for(int i = 2; i <= val / 2; i++) {
      if (val % i == 0) {
        isPrime = false;
        break;
      }
    }

    return isPrime;
  }
}
