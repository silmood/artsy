public class DynamicWave {
  private float period;
  private float displayWidth;
  private float amplitude;
  private float pointTheta;
  private float[] points;
  private int pointLimit;
  private int pointCount;
  private float theta;
  private int speed;
  private float origin;
  private float noise;
  private float pointNoise;
  private color c;
  private float[][] trails;
  private int trailsCount;
  private int trailsLimit;
  private PVector trailOffset;

  public DynamicWave (float period,
                      float amplitude,
                      int displayWidth,
                      int speed,
                      float origin,
                      color c, 
                      PVector trailOffset) {

    this.period = period;
    this.amplitude = amplitude;
    this.theta = 0;
    this.speed = speed;
    this.origin = origin;
    this.noise = random(10);
    this.pointNoise = random(10);
    this.c = c;
    this.pointTheta = ((TWO_PI * period) / displayWidth);
    this.points = new float[floor(displayWidth)];
    this.trailsLimit = 10;
    this.trails = new float[trailsLimit][floor(displayWidth)];
    this.trailOffset = trailOffset;
    this.trailsCount = 0;
    this.pointLimit = 0;
    this.pointCount = 0;
  }

  private void calcWave() {
    int s = floor(this.speed + ((noise(noise) * 4) - 2));

    if (pointLimit < points.length - 1) {
      for(int i = 0; i < s && pointLimit < points.length - 1; i++) {
        float rad = pointTheta * pointCount;
        points[pointLimit] = sin(rad) * noise(noise);
        noise += 0.025;
        pointLimit++;
        pointCount++;
      }
    } else {
      for(int i = 0; i < pointLimit - s; i++) {
        points[i] = points[i + s];
      }

      for (int i = pointLimit - s; i < pointLimit; i++) {
        float rad = pointTheta * pointCount;
        points[i] = sin(rad) * noise(noise);
        noise += 0.025;
        pointCount++;
      }

    }

    pointNoise += 0.00025;
  }

  public void draw() {
    calcWave();

    int limit = pointLimit - floor(noise(pointNoise) * 200);
    color c1 = color(261, 100, 69);
    color c2 = color(196, 97, 80);
    color st = lerpColor(c1, c2, 0.0);

    drawCurve(st, 0.95, limit);
    drawTrails(15, c1, c2, limit);
  }

  private void drawCurve(color c, float weight, int pointLimit) {
    beginShape();

    for(int i = 0; i < pointLimit; i++) {
      float x = i;
      float y = origin + points[i] * amplitude;

      curveVertex(x, y);

      if(i == pointLimit - 1) {
        drawStarship(x, y);
      }
    }
    strokeWeight(weight);
    stroke(c);
    endShape();
  }

  private void drawTrails(int trailsCount, color c1, color c2, int pointLimit) {
    for(int i = 0; i < trailsCount ; i++) {
      pushMatrix();
      translate(-trailOffset.x * i, -trailOffset.y * i);

      float weight = (trailsCount - i) * 0.025;
      color st = lerpColor(c1, c2, map(i, 0, 15, 0.2, 0.9));
      drawCurve(st, weight, pointLimit);

      popMatrix();
    }
  }

  private void drawStarship(float x, float y) {
    strokeWeight(1);
    stroke(360);
    point(x, y);
  }

}
