void setup() {
  size(756, 756);
  smooth();
  background(0);

  float particleRadius = 1.0;
  float circleRadius = width / 4.0;
  PVector center = new PVector(width / 2, height / 2);

  UlamCircle spiral = new UlamCircle(particleRadius, circleRadius, center);
  spiral.draw();
}
