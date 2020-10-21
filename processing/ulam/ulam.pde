int cols = 180;
int rows = 180;

void setup() {
  size(512, 512);
  background(0);

  float cellW = width / parseFloat(cols);
  float cellh = height / parseFloat(rows);

  Table table = new Table(cols, rows, cellW, cellh);
  table.draw();
}
