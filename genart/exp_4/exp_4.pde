import processing.opengl.*;

PVector noise;
PVector startNoise;

void setup() {
  size(512, 512, OPENGL);
  sphereDetail(8);
  colorMode(HSB, 360, 100, 100);

  startNoise = new PVector(random(20), random(20));
  noise = new PVector(random(10), random(10));
}

void draw() {
  background(0);
  startNoise.sub(0.1, 0.1);

  noise.add(
    (noise(startNoise.x) * 0.5) - 0.25,
    (noise(startNoise.y) * 0.5) - 0.25
  );

  drawGrid(noise);
}

PVector drawGrid(PVector noise) {
  float xStart = noise.x;
  float xNoise = xStart;
  float yNoise = noise.y;

  for (int y = 0; y <= height; y += 5) {
    yNoise += 0.1;
    xNoise = xStart;
    for (int x = 0; x <= width; x += 5) {
      xNoise += 0.1;
      float noiseFactor = noise(xNoise, yNoise);
      drawSphere(x, y, noiseFactor);
    }
  }

  return new PVector(xNoise, yNoise);
}

void drawRect(float x, float y, float noise) {
  float len = 10 * noise;
  rect(x, y, len, len);
}

void drawSphere(float x, float y, float noise) {
  float size = 35 * noise;
  float alpha = 75 + (noise * 120);

  pushMatrix();
  translate(x, 410 - y, -y);

  noStroke();
  fill(0, 0, 100 + ((noise * 50) - 25), alpha);
  sphere(size);

  popMatrix();
}

void drawLineRotation(float x, float y, float noise) {
  pushMatrix();
  translate(x, y);
  rotate(TWO_PI * noise);
  
  stroke(255, 150);
  line(0, 0, 20, 0);
  popMatrix();
}

void drawLineColor(float x, float y, float noise) {
  int alpha = int(noise * 255);
  pushMatrix();
  translate(x, y);
  rotate(TWO_PI * noise);

  strokeWeight(1 * noise);
  stroke(196 + ((noise * 100) - 50), 100, 100);
  line(0, 0, 20, 0);
  popMatrix();
}

