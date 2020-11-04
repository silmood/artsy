void setup() {
  size(512, 512);
  noFill();
  strokeWeight(4);
}

void draw() {
  background(255);  
  drawFx2();
  drawFx3();
}

void drawFx2() {
  stroke(255, 0, 0);
  pushMatrix();
  translate(width / 2, height / 2);


  // Main quadratic curve
  float fx2Max = fx2(width / 2);
  float fx2Scale = height / fx2Max;

  beginShape();
  for (int i = -width / 2; i < width / 2; i++) {
    vertex(i, fx2(i) * fx2Scale);    
  }

  endShape();

  // Second quadratic curve
  beginShape();
  stroke(0, 255, 0);

  for (int i = -width / 2; i < width / 2; i++) {
    vertex(i, fx2b(i) * fx2Scale);    
  }

  endShape();

  // Third quadratic curve
  beginShape();
  stroke(0, 0, 255);

  for (int i = -width / 2; i < width / 2; i++) {
    vertex(i, fx2c(i) * fx2Scale);    
  }

  endShape();
  popMatrix();
}

float fx2(float x) {
  return (x * x);
}

float fx2b(float x) {
  return 6 * (x * x);
}

float fx2c(float x) {
  return -(2 * (x * x)); 
}

void drawFx3() {
  pushMatrix();
  translate(width / 2, height / 2);

  stroke(255, 127, 0);

  beginShape();
  float fx3Max = fx3(width / 2);
  float fx3Scale = height / (fx3Max * 2);

  for (int i = -width; i < width / 2; ++i) {
    vertex(i, fx3(i) * fx3Scale);    
  }
  endShape();

  stroke(127,0, 127);
  beginShape();

  for (int i = -width; i < width / 2; ++i) {
    vertex(i, fx3b(i) * fx3Scale);    
  }
  endShape();

  stroke(0,127, 127);
  beginShape();

  for (int i = -width; i < width / 2; ++i) {
    vertex(i, fx3c(i) * fx3Scale);    
  }
  endShape();
  popMatrix();
}

float fx3(float x) {
  return x * x * x;
}

float fx3b(float x) {
  return 4 * (x * x * x) +  (-500 * (x * x));
}

float fx3c(float x) {
  return -8 * (x * x * x) +  (200 * (x * x));
}
