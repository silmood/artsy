
void setup() {
  size(768, 768);
}

void draw() {
  background(0);
  translate(width / 2, height / 2);

  float tightness = map(mouseX, 0, width, -1, 1);
  drawCurveEllipse(25, width / 4, tightness);
}

void drawCurveEllipse(int points, float radius, float tightness) {
  float theta = 0;
  PVector control = new PVector(0, 0);
  PVector anchor = new PVector(0, 0);
  float rotation = TWO_PI / points;
  curveTightness(tightness);

  beginShape();

  for (int i = 0; i < points; ++i) {
    if (i == 0) {
      control.x = cos(theta - rotation) * radius;
      control.y = sin(theta - rotation) * radius;
      anchor.x = cos(theta) * radius;
      anchor.y = sin(theta) * radius;

      curveVertex(control.x, control.y);
      curveVertex(anchor.x, anchor.y);
    } else {
      anchor.x = cos(theta) * radius;
      anchor.y = sin(theta) * radius;

      curveVertex(anchor.x, anchor.y);
    }

    if (i == points - 1) {
      control.x = cos(theta + rotation) * radius;
      control.y = sin(theta + rotation) * radius;
      anchor.x = cos(theta + rotation * 2) * radius;
      anchor.y = sin(theta + rotation * 2) * radius;

      curveVertex(control.x, control.y);
      curveVertex(anchor.x, anchor.y);
    }

    theta += rotation;
  }

  fill(255);
  endShape();
}
