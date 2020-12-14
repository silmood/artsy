public class DynamicWave {
  private float period;
  private float displayWidth;
  private float amplitude;
  private float pointTheta;
  private float xOffset;
  private float[] points;
  private int pointLimit;
  private int pointCount;
  private float theta;
  private float speed;
  private float origin;
  private float noise;
  private color c;
  private float[][] trails;
  private int trailsCount;
  private int trailsLimit;

  public DynamicWave (float period, float amplitude, int displayWidth, float speed, float origin, color c) {
    this.period = period;
    this.amplitude = amplitude;
    this.theta = 0;
    this.speed = speed;
    this.origin = origin;
    this.noise = random(10);
    this.c = c;
    this.xOffset =  0; //(TWO_PI / this.period) * random(-100, 100);
    this.pointTheta = ((TWO_PI * period) / displayWidth);
    this.points = new float[floor(displayWidth)];
    this.trailsLimit = 10;
    this.trails = new float[trailsLimit][floor(displayWidth)];
    this.trailsCount = 0;
    this.pointLimit = 0;
    this.pointCount = 0;
  }

  private void calcWave() {
    int speed = floor(10 + ((noise(noise) * 4) - 2));

    if (pointLimit < points.length - 1) {
      for(int i = 0; i < speed && pointLimit < points.length - 1; i++) {
        float rad = pointTheta * pointCount;
        //points[pointLimit] = noise(noise); 
        points[pointLimit] = sin(rad) * noise(noise);
        noise += 0.0025;
        pointLimit++;
        pointCount++;
      }
    } else {
      for(int i = 0; i < pointLimit - speed; i++) {
        points[i] = points[i + speed];
      }

      for (int i = pointLimit - speed; i < pointLimit; i++) {
        float rad = pointTheta * pointCount;
        points[i] = sin(rad) * noise(noise);
        noise += 0.0025;
        pointCount++;
      }

    }
  }

  public void draw() {
    calcWave();

    beginShape();
    int limit = pointLimit - floor(noise(noise) * 200);

    for(int i = 0; i < limit; i++) {
      float x = i;
      float y = origin + points[i] * amplitude;

      vertex(x, y);

      if(i == limit - 1) {
        drawStarship(x, y);
      }
    }
    strokeWeight(0.25);
    stroke(c);
    endShape();

    for(int i = 0; i < 5 ; i++) {
      pushMatrix();
      translate(-20 * i, 0);
      
      beginShape();

      for(int j = 0; j < limit; j++) {
        float x = j;
        float y = origin + points[j] * amplitude;

        vertex(x, y);

        if(j == limit - 1) {
          drawStarship(x, y);
        }
      }

      strokeWeight(0.05);
      stroke(c);
      endShape();

      popMatrix();
    }
  }

  private void drawStarship(float x, float y) {
    strokeWeight(2);
    stroke(360);
    point(x, y);
  }

}
