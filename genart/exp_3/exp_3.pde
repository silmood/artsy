PVector noise;
PVector startNoise;
boolean activeMoveNoise;
boolean activeToggle;
boolean recording;
float theta;

void setup() {
  size(316, 316);
  pixelDensity(displayDensity());
  smooth();

  colorMode(HSB, 360, 100, 100);
  startNoise = new PVector(random(20), random(20));
  noise = new PVector(random(10), random(10));
  theta = 0;
  activeMoveNoise = false;
  activeToggle = true;
  recording = true;
}

void draw() {
  background(0);
  if (activeMoveNoise) {
    startNoise.sub(0.1, 0.1);

    noise.add(
      (noise(startNoise.x) * 0.5) - 0.25,
      (noise(startNoise.y) * 0.5) - 0.25
    );
  } else {
    noise.sub(0.1, 0.1);
  }

  drawGrid(noise);
  theta += TWO_PI / 32;

  if (recording)
    saveFrame("exp_3-####.png");
  
  if (theta >= 4 * TWO_PI)
    recording = false;
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
      float noiseFactor = activeToggle ? 
        map(sin(theta), -1, 1, 0.25, 1) * noise(xNoise, yNoise) :
        noise(xNoise, yNoise);
      drawLineColor(x, y, noiseFactor);
    }
  }

  return new PVector(xNoise, yNoise);
}

void drawRect(float x, float y, float noise) {
  float len = 10 * noise;
  rect(x, y, len, len);
}

void drawCircle(float x, float y, float noise) {
  float len = 35 * noise;
  float alpha = 75 + (noise * 120);

  pushMatrix();
  translate(x, y);
  rotate(TWO_PI * noise);

  noStroke();
  fill(290 + ((noise * 200) - 100), 85, 85, alpha);
  ellipse(0, 0, len, len / 2);

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
  int alpha = 150 + int(noise * 120);
  pushMatrix();
  translate(x, y);
  rotate((2 * TWO_PI) * noise);

  strokeWeight(0.75 * noise);
  stroke(210 + ((noise * 100) - 50), 100, 100, alpha);
  line(0, 0, 20, 0);
  popMatrix();
}

void mousePressed() {
  recording = false;
}
