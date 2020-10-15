float angle;
float angleTriangle;
PVector origin;

void setup() {
  size(512, 512);
  smooth();
  angle = 0.0;
  angleTriangle = 0.0;
  origin = new PVector(width / 2, height / 2);
}

void draw() {
  background(0);
  fill(0);
  stroke(255);

  float r = map(mouseX, 0, width, 10, 200);

  ellipseMode(RADIUS);
  ellipse(origin.x, origin.y, r, r);
  
  for (int i = 0; i < 3; i ++) {
    float arc =  PI / 1.5;
    float x = r * cos(angle + (arc * i));
    float y = r * sin(angle + (arc * i));
    PVector triangleOrigin = new PVector(origin.x + x, origin.y + y);
    polygon(triangleOrigin, 100, angleTriangle);
 }

  angle += 0.05;
  angleTriangle += map(mouseX, 0, width, 0.05, 1.5);
}

void polygon(PVector origin, float radius, float startAngle) {
  float arc = PI / 1.5;
  pushMatrix();
  translate(origin.x, origin.y);

  stroke(65);
  ellipseMode(RADIUS);
  ellipse(0, 0, radius, radius);

  stroke(155);
  beginShape();

  for (int i = 0; i < 3; i++) {
    float theta = startAngle + (arc * i);
    PVector v = calculateVertex(theta, radius);
    vertex(v.x, v.y);

    strokeWeight(10);
    point(v.x, v.y);
    strokeWeight(1);
  }

  endShape(CLOSE);
  popMatrix();
}

PVector calculateVertex(float theta, float radius) {
  float x = cos(theta) * radius;
  float y = sin(theta) * radius;

  return new PVector(x, y);
}
