DynamicWave[] waves;
float waveOffset;
boolean recording;

void setup() {
  size(512, 512);
  pixelDensity(displayDensity());
  smooth();
  noFill();

  waveOffset = 30;
  waves = new DynamicWave[5];
  recording = false;

  setupWaves();
}

void draw() {
  background(0);
  for(DynamicWave wave : waves) {
    wave.draw();
  }
}

void setupWaves() {
  float position = ((height / 2) - ((waveOffset * waves.length) / 2)) + 45;

  colorMode(HSB, 360, 100, 100);
  color c1 = color(random(280, 360), 99, 82);
  color c2 = color(random(65, 128), 98, 96);

  for(int i = 0; i < waves.length; i++) {
    color stroke = lerpColor(c1, c2, map(i, 0, waves.length -1, 0, 0.5));
    float period = random(1, 3);
    float amplitude = random(120, 156);
    int displayWidth = 4 * (width / 4);
    int speed = 6;
    PVector offset = new PVector(3, 3);

    waves[i] = new DynamicWave(period, amplitude, displayWidth, speed, position, stroke, offset);
    position += waveOffset;
  }
}
