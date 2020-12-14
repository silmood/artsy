public class Wave {
  private float period;
  private float displayWidth;
  private float amplitude;
  private float pointOffset;
  private float pointTheta;
  private float xOffset;
  private float[] points;
  private float theta;
  private float speed;
  private float origin;
  private float noise;
  private color c;

  public Wave (float period, float amplitude, int displayWidth, float speed, float origin, float pointOffset, color c) {
    this.period = period;
    this.amplitude = amplitude;
    this.theta = 0;
    this.pointOffset = pointOffset;
    this.speed = speed;
    this.origin = origin;
    this.noise = random(10);
    this.c = c;
    this.xOffset = (TWO_PI / this.period) * random(-100, 100);
    this.pointTheta = (TWO_PI / this.period) * pointOffset;
    this.points = new float[floor(displayWidth / pointOffset)];

  }

  private void calcWave() {
    theta += speed;

    for(int i = 0; i < points.length; i++) {
      float rad = (pointTheta * i) + theta + xOffset;
      points[i] = sin(rad);
    }
  }

  public void draw() {
    calcWave();

    beginShape();
    int limit = points.length;

    for(int i = 0; i < points.length; i++) {
      float x = i * pointOffset;
      float y = origin + points[i] * amplitude;

      vertex(x, y);

      if(i == limit - 1) {
        drawStarship(x, y);
      }
    }
    strokeWeight(2);
    stroke(c);
    endShape();
  }

  private void drawStarship(float x, float y) {
    strokeWeight(10);
    stroke(360);
    point(x, y);
  }

}
