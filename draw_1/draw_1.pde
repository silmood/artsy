int triangleSize = 150;
int lineLength = 356;
int rectSize = 100;

float angle = 0;
int centerX;
int centerY;

void setup() {
  smooth();
  size(512, 512);
  
  centerX = width / 2;
  centerY = height / 2;
}

void draw() {
  background(0);
  
  drawTriangles(centerX / 2, centerY, 30);
  drawTriangles(centerX, centerY, 90);
  drawTriangles((centerX / 2) * 3, centerY, 30);
  
  drawLines(centerX / 2, centerY);
  drawLines(centerX, centerY);
  drawLines((centerX / 2) * 3, centerY);
 
  if(angle < 360) angle += 0.25;
  else angle = 0;
}

void drawTriangles(int centerX, int centerY, int phase) {
  for(int i = 0; i < 15; i ++){
    float centerAngle = (angle + phase) - (i * 0.25);
    
    float aX = triangleSize * cos(centerAngle - 10);
    float aY = triangleSize * sin(centerAngle - 10);
    float bX = triangleSize * cos(centerAngle + 10);
    float bY = triangleSize * sin(centerAngle + 10);
    
    noStroke();
    fill(255, 155 - (i * 9));
    
    triangle(centerX, centerY,
        centerX + aX, centerY + aY,
        centerX + bX, centerY + bY);
  }
}

void drawLines(int centerX,  int centerY) {
  for(int i = 0; i < 25; i ++){
    float lineAngle = angle - (i * 0.15);
    float lineX = lineLength * cos(lineAngle);
    float lineY = lineLength * sin(lineAngle);
    stroke(255, 255 - (i * 10));
    line(centerX - lineX, centerY  - lineY, centerX + lineX, centerY + lineY);
  }
}
