int points;
float radius;
float controlRadius;
float controlTheta1;
float controlTheta2;
float radiusLimitMax;
float radiusLimitMin;
float rotationSpeed;
float rotationTheta;
float blinkSpeed;
float blinkTheta;
boolean debugging;
boolean recording;

void setup() {
  size(512, 512);
  smooth();

  debugging = false;
  recording = false;
  radiusLimitMin = width / 8.0;
  radiusLimitMax = width / 3.0;
  rotationSpeed = PI / 120;
  blinkSpeed = PI / 60;
  rotationTheta = 0;
  blinkTheta = 0;

  generateRandomCubic();
}

void draw() {
  background(0);
  strokeWeight(0.5);
  noFill();
  pushMatrix();
  translate(width / 2, height / 2);

  int p = floor(map(sin(blinkTheta), -1, 1, 4, points));

  for (float gradientTheta = PI; gradientTheta < TWO_PI; gradientTheta += PI / 16) {
    float cR = map(gradientTheta, PI, TWO_PI, controlRadius, controlRadius * 0.75);
    float r = map(gradientTheta, PI, TWO_PI, radius, radius  * 0.75);
    float percentage = abs(sin(gradientTheta));
    color stroke = lerpColor(color(238, 57, 196), color(37, 52, 142), percentage);


    stroke(stroke);
    bezierEllipse(
      p,
      r,
      cR,
      controlTheta1,
      controlTheta2
      );
  }

  popMatrix();
  debuggingControls();

  rotationTheta += rotationSpeed;
  blinkTheta += blinkSpeed;

  if (recording)
    saveFrame("cubic-####.png");

  if (rotationTheta >= TWO_PI)
    recording = false;
}

void bezierEllipse(int points, float radius, float controlRadius, float controlTheta1, float controlTheta2) {
  beginShape();
  PVector control1 = new PVector(0, 0);
  PVector control2 = new PVector(0, 0);
  PVector anchor = new PVector(0, 0);
  float rotation = TWO_PI / points;
  float start = rotationTheta;
  float theta = start;


  for (int i = 0; i < points; i++) {
    control1.x = cos(theta + controlTheta1) * controlRadius;
    control1.y = sin(theta + controlTheta1) * controlRadius;

    control2.x = cos(theta + controlTheta2) * controlRadius;
    control2.y = sin(theta + controlTheta2) * controlRadius;

    anchor.x = cos(theta + rotation) * radius;
    anchor.y = sin(theta + rotation) * radius;

    if (i == 0) {
      vertex(cos(start) * radius, sin(start) * radius);
    } 
    
    if (i == points - 1) {
      bezierVertex(control1.x, control1.y, control2.x, control2.y, cos(start) * radius, sin(start) * radius);
    } else {
      bezierVertex(control1.x, control1.y, control2.x, control2.y, anchor.x, anchor.y);
    }

    // Draw Handlers
    
    // fill(0, 0, 255);
    // rect(control1.x - 3, control1.y - 3, 6, 6);
    // fill(0, 255, 255);
    // rect(control2.x - 3, control2.y - 3, 6, 6);
    // fill(255, 127, 0);
    // ellipse(anchor.x, anchor.y, 6, 6);

    theta += rotation;
  }
  endShape();
}

void generateRandomCubic() {
  points = floor(random(4, 50));
  radius = random(radiusLimitMin, radiusLimitMax);
  controlRadius = random(radiusLimitMin, radiusLimitMax);
  controlTheta1 = random(0, TWO_PI);
  controlTheta2 = random(0, TWO_PI);
}

void debuggingControls() {
  if(!debugging) return;

  fill(255);
  text("Points: " + points, width - 124, height - 60);
  text("Radius: " + radius, width - 124, height - 48);
  text("CR: " + controlRadius, width - 124, height - 36);
  text("CT1: " + controlTheta1, width - 124, height - 24);
  text("CT2: " + controlTheta2, width - 124, height - 12);
}

void mousePressed() {
  generateRandomCubic();
}
