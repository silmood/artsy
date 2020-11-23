Box[][] grid;
Stick stick;

void setup() {
  size(512, 512);
  grid = generateGrid(1, 1);

  int stickLen = 80;
  Ball b1 = new Ball(width / 2, height / 2, 10, color(229, 32, 229), new PVector(width, height));
  Ball b2 = new Ball(width / 2, height / 2 - stickLen, 10, color(229, 32, 229), new PVector(width, height));
  stick = new Stick(b1, b2);
}

void draw() {
  background(255);
  stick.update();
  stick.draw();
}

void drawGrid() {
  background(255);
  for (Box[] column : grid) {
    for (Box box: column) {
      box.draw();
    }
  }
}

Box[][] generateGrid(int rows, int columns) {
  Box[][] grid = new Box[rows][columns];
  float itemWidth = width / columns;
  float itemHeight = height / rows;
  float y = 0;

  for (int row = 0; row < rows ; row++, y += itemHeight) {
    float x = 0;
    for (int col = 0; col < columns; col++, x+= itemWidth) {
      grid[row][col] = new Box(x, y, itemWidth, itemHeight, floor(random(10, 20)));
    }
  }

  return grid;
}
