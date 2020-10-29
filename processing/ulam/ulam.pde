float particleRadius;
float circleRadius;
PVector center;
UlamCircle ulamCircle;

void setup() {
  size(756, 756);
  smooth();

  particleRadius = 0.5;
  circleRadius = 5 * (width / 12.0);
  center = new PVector(width / 2, height / 2);
  ulamCircle = new UlamCircle(particleRadius, circleRadius, center);

}

void draw() {
  background(0);
  ulamCircle.draw();
}
