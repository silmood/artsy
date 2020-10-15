float angle;
float angleTriangle;
float bulbAngle;
float ecoAngle;
PVector origin;

void setup() {
  size(728, 728);
  smooth();
  angle = 0.0;
  angleTriangle = 0.0;
  origin = new PVector(width / 2, height / 2);
}

void draw() {
  background(0);
  fill(0);
  stroke(255);

  float r = map(sin(angle), -1, 1, 10, 200);
  
  // Dynamic Eco
  // float rEco = map(mouseX, 0, width, 156, 356);
  
  drawCircleEco(origin, 512);
  
  for (int i = 0; i < 3; i ++) {
    float arc =  PI / 1.5;
    float x = r * cos(angle + (arc * i));
    float y = r * sin(angle + (arc * i));
    PVector triangleOrigin = new PVector(origin.x + x, origin.y + y);

    polygon(triangleOrigin, 100, angleTriangle, (i + 3));
 }

  ecoAngle += PI / 60;
  bulbAngle += PI / 8;
  angle += 0.055;
  angleTriangle += map(sin(angle), -1, 1, 0.15, 2.5);
}

void polygon(PVector origin, float radius, float startAngle, int edges) {
  float arc = PI / (edges / 2.0);
  pushMatrix();
  translate(origin.x, origin.y);

  stroke(65);
  ellipseMode(RADIUS);
  ellipse(0, 0, radius, radius);

  beginShape();

  for (int i = 0; i < 2; i++) {
    stroke(255);
    float theta = startAngle + (arc * i);
    PVector v = calculateVertex(theta, radius);
    vertex(v.x, v.y);

    float saturation = map(sin(bulbAngle), 0, 1, 100, 255);
    stroke(saturation);
    strokeWeight(10);
    point(v.x, v.y);
    strokeWeight(1);
    stroke(155);
  }

  endShape(CLOSE);
  popMatrix();
}

void drawCircleEco(PVector origin, float r) {
  pushMatrix();

  translate(origin.x, origin.y);
  ellipseMode(RADIUS);

  for(float i = r; i >= 0; i -= 10){
    float max = map(i, 0, r, 100, 255);
    float stroke = map(sin(ecoAngle), 0, 1, 100, max);
    stroke(stroke);
    ellipse(0, 0, i, i);
  }

  popMatrix();
}

PVector calculateVertex(float theta, float radius) {
  float x = cos(theta) * radius;
  float y = sin(theta) * radius;

  return new PVector(x, y);
}
