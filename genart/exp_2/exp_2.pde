DynamicWave[] waves;
float waveOffset;

void setup() {
  size(1024, 512, P2D);
  smooth();
  noFill();

  waveOffset = 5;
  waves = new DynamicWave[10];

  setupWaves();
}

void draw() {
  background(0);

  for(DynamicWave wave : waves) {
    wave.draw();
  }
}

void setupWaves() {
  float position = (height / 2) - ((waveOffset * waves.length) / 2);

  colorMode(HSB, 360, 100, 100);
  color c1 = color(321, 97, 97);
  color c2 = color(243, 76, 78);

  for(int i = 0; i < waves.length; i++) {
    color stroke = lerpColor(c1, c2, map(i, 0, waves.length, 0, 1));
    float period = random(2, 3);
    float amplitude = random(80, 90);
    int displayWidth = 3 * (width / 4);
    float speed = random(0.25);

    waves[i] = new DynamicWave(period, amplitude, displayWidth, speed, position, stroke);
    position += waveOffset;
  }
}
