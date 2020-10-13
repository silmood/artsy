float[][] nextV = new float[4][2];
float[][] v = {{0, 0}, {0, 0}, {0, 0}, {0, 0}};
boolean nextQuad = true;
int acc = 1;

void setup() {
  size(512, 512);
}

void draw() {
  background(0);

  nextQuad = calculateNextStep(acc);
  drawQuad();

  if (nextQuad && frameCount % 20 == 0) {
    generateRandomizedQuad(width / 4, height / 4, 256, 256);
    acc = 1;
  } else {
    acc++;
  }

}

void drawQuad() {
  fill(255);
  beginShape();

  for (int i = 0; i < v.length; i ++) {
    vertex(v[i][0], v[i][1]);
  }

  endShape(CLOSE);
}

void generateRandomizedQuad(float x, float y, float w, float h) {
  float jitterW = 0.5 * w;
  float jitterH = 0.2 * h;

  nextV[0] = new float[]{x + random(-jitterW, jitterW), y + random(-jitterH, jitterH)};
  nextV[1] = new float[]{x + random(-jitterW, jitterW), y + h + random(-jitterH, jitterH)};
  nextV[2] = new float[]{x + w + random(-jitterW, jitterW), y + h + random(-jitterH, jitterH)};
  nextV[3] = new float[]{x + w + random(-jitterW, jitterW), y + random(-jitterH, jitterH)};
}

boolean calculateNextStep(int acc) {
  boolean finished = true;

  for(int i = 0; i < v.length; i++) {
    finished = finished && v[i][0] == nextV[i][0] && v[i][1] == nextV[i][1];

    for(int j = 0; j < 2; j++) {
      if (v[i][j] != nextV[i][j]) {
        if(v[i][j] + (2 * acc) <= nextV[i][j]) v[i][j] += (2 * acc);
        else if(v[i][j] - (2 * acc) >= nextV[i][j]) v[i][j] -= (2 * acc);
        else {
          v[i][j] = nextV[i][j];
        }
      }
    }
  }

  return finished;
}