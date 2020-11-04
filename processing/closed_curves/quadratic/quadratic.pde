void setup() {
  size(512, 512);
  smooth();
  noFill();
}

void draw() {
  pushMatrix();
  translate(width / 2, height / 2);
  background(0);
  stroke(255);


  beginShape();

  int limbs = 56;
  float controlRadius = map(mouseX, 0, width, 0, width / 4);
  float limbRadius = map(mouseY, 0, width, 0, width / 4);
  float theta = 0;  
  float cx = 0, cy = 0;
  float ax = 0, ay = 0;
  float rotation = TWO_PI / (limbs * 2);

  for(int i = 0; i < limbs; i++) {
    cx = cos(theta) * controlRadius;
    cy = sin(theta) * controlRadius;
    theta += rotation;
    ax = cos(theta) * limbRadius;
    ay = sin(theta) * limbRadius;

    if (i == 0) {
      vertex(ax, ay);
    } else {
      quadraticVertex(cx, cy, ax, ay);

      // Draw anchor and control points 
      // fill(0, 0, 255);
      // rect(cx - 3, cy -3, 6, 6);
      // fill(255, 0, 0);
      // ellipse(ax, ay, 6, 6);
      // line(ax, ay, cx, cy);
    }

    theta += rotation;

    if(i == limbs - 1) {
      cx = cos(0) * controlRadius;
      cy = sin(0) * controlRadius;
      ax = cos(rotation) * limbRadius;
      ay = sin(rotation) * limbRadius;
      quadraticVertex(cx, cy, ax, ay);

      // rect(cx - 3, cy -3, 6, 6);
      // ellipse(ax, ay, 6, 6);
      // line(ax, ay, cx, cy);
    }
  }

  endShape();

  popMatrix();
}
