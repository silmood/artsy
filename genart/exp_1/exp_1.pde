float step;
float radius;
float angle;
float rNoise, aNoise, xNoise, yNoise, vNoise, vNoise2, cNoise;
int figures[];
int currentFigure;
boolean inverse = true;

void setup() {
  size(816, 816);
  smooth();
  inverse = false;
  radius = width / 2.0;
  angle = 0;
  figures = new int[] {2, 3, 4};
  currentFigure = 0;
  resetNoise();
  background(0);
  colorMode(HSB, 360, 100, 100);
  noFill();
}

void draw() {
  color c1 = color(321 + ((noise(cNoise) * 150)- 75) , 97, 97);
  color c2 = color(243 + ((noise(cNoise) * 150) - 75), 76, 78);
  color stroke = lerpColor(c1, c2, abs(cos(angle)));
  pushMatrix();

  float cx = width / 2 + (noise(xNoise) * 112) - 112/2.0;
  float cy = height / 2 + (noise(yNoise) * 112) - 112/2.0;

  translate(cx , cy);

  beginShape();

  int vertex = figures[currentFigure];

  for (int i = 0; i < vertex; i++) {
    float r = radius * noise(rNoise);
    float rad = (angle + (i * (TWO_PI) / map(sin(angle), -1, 1, 2, vertex)));
    float x = r * (cos(rad));
    float y = r * (sin(rad));

    //float rad = (angle + (i * (TWO_PI) / vertex));
    //float rad = (angle + (i * ((noise(vNoise) * TWO_PI) / (noise(vNoise2) * 4))));

    vertex(x, y);
    strokeWeight(1.5);
    stroke(360);
    point(x, y);

    vNoise += 0.00057;
    vNoise2 += 0.00027;
  }

  strokeWeight(0.05);
  stroke(stroke);
  endShape(CLOSE);
  popMatrix();

  inverse = angle > TWO_PI || angle < 0 ? !inverse : inverse;
  angle += (inverse ? -1 : 1) * ((noise(aNoise) * PI / 186)); //- PI / 228);

  rNoise += 0.00768;
  aNoise += 0.0366;
  cNoise += 0.00076;
  xNoise += 0.01;
  yNoise += 0.01;

  if (angle >= TWO_PI) {
    currentFigure = currentFigure == figures.length - 1 ? 0 : currentFigure + 1;
  }
}

void mousePressed() {
  saveFrame("exp_1-####.jpg");  
  background(0);
}

void resetNoise() {
  xNoise = random(10);
  yNoise = random(10);
  rNoise = random(10);
  aNoise = random(10);
  vNoise = random(10);
  vNoise2 = random(10);
  cNoise = random(10);
}

