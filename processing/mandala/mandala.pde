void setup() {
  size(512, 512);
}

void draw() {
  background(0);
  mandala(
    3,
    new PVector(width / 2, height / 2),
    floor(map(mouseX, 0, width, 2, 50)),
    10,
    75,
    map(mouseY, 0, width, 0, TWO_PI),
    frameCount * (TWO_PI / 180)
  );
}

void mandala(
  int pointCount,
  PVector origin,
  int steps,
  float radius, 
  float innerFactor,
  float rotation,
  float offset) {

  float innerRadius = innerFactor * radius;
  float outerRadiusRatio = radius / steps;
  float innerRadiusRatio = innerRadius / steps;
  float shadeRatio = 255 / steps;
  float rotationRatio = rotation / steps;

  for (int i = 0; i < steps; i++) {
    float outer = radius - outerRadiusRatio * i;
    float inner = innerRadius - innerRadiusRatio * i;

    stroke(shadeRatio * i, 100);
    fill(shadeRatio * i);

    pushMatrix();
    translate(origin.x, origin.y);
    rotate((rotationRatio * i) + offset);
    star(pointCount, outer, inner);
    popMatrix();
  }
}

void star(int pointCount, float innerRadius, float outerRadius) {
  float theta = 0.0;
  int vertCount = pointCount * 2;
  float rotation = TWO_PI / vertCount;

  beginShape();

  for (int i = 0; i < pointCount; i++) {
    for (int j = 0; j < 2; j++) {
      float radius = j % 2 == 0 ? outerRadius : innerRadius;

      float x = radius * cos(theta);
      float y = radius * sin(theta);

      vertex(x, y);

      theta += rotation;
    }
  }

  endShape(CLOSE);
}
