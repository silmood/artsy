float particleRadius;
float circleRadius;
PVector center;
UlamCircle ulamCircle;
boolean recording;

void setup() {
  size(756, 756);
  smooth();

  recording = true;
  particleRadius = 2;
  circleRadius = 5 * (width / 12.0);
  center = new PVector(width / 2, height / 2);
  ulamCircle = new UlamCircle(particleRadius, circleRadius, center);

}

void draw() {
  background(22, 22, 22);
  ulamCircle.draw();

  if(recording)
    saveFrame("demo-##########.png");

  if(frameCount * (TWO_PI / 64) >= TWO_PI)
    recording = false;
}
