PVector squareCenter;
float squareAngle;
float squareWidth;
PVector squareSpeed;
float rotationSpeed;

// First Collission Approach
float cornerRadiusOffset;
float dynamicRadius;
float dynamicRadius2;

float collisionTheta;

// Second Collission Approach
PVector squareVertex[];

void setup() {
  size(512, 512);

  squareCenter = new PVector(width / 2, height / 2);
  squareAngle = 0;
  squareWidth = 60;
  squareSpeed = new PVector(1, 1.5);
  rotationSpeed = PI / 180;
  cornerRadiusOffset = squareWidth / 2 / cos(PI / 4) - squareWidth / 2;
  squareVertex = new PVector[] { new PVector(0, 0), new PVector(0, 0), new PVector(0, 0), new PVector(0,0) };

  fill(0, 175, 175);
  noStroke();
}

void draw() {
  drawTrig();
}

void drawTrig() {
  background(255, 0 , 127);
  pushMatrix();

  translate(squareCenter.x, squareCenter.y);
  beginShape();

  float angle = squareAngle;
  for (int i = 0; i < 4; i++) {
    float x = cos(angle) * squareWidth;
    float y = sin(angle) * squareWidth;

    squareVertex[i].x = squareCenter.x + x;
    squareVertex[i].y = squareCenter.y + y;

    vertex(x, y);
    angle += TWO_PI / 4.0;
  }
  endShape();
  popMatrix();

  squareCenter.x += squareSpeed.x;
  squareCenter.y += squareSpeed.y;
  squareAngle += rotationSpeed;

  detectCollission();
}

void detectCollission() {
  for (int i = 0; i < 4; i++) {

    if(squareVertex[i].x >= width) {
      squareSpeed.x = abs(squareSpeed.x) * -1;
    } else if (squareVertex[i].x <= 0) {
      squareSpeed.x = abs(squareSpeed.x);
    }

    if(squareVertex[i].y >= height) {
      squareSpeed.y = abs(squareSpeed.y) * -1;
    } else if (squareVertex[i].y <= 0) {
      squareSpeed.y = abs(squareSpeed.y);
    }
  }
}

void drawNormal() {
  background(255, 0, 127);

  pushMatrix();
  translate(squareCenter.x, squareCenter.y);
  rotate(squareAngle);

  rect(-squareWidth / 2, -squareWidth/2, squareWidth, squareWidth);

  popMatrix();

  squareCenter.x += squareSpeed.x;
  squareCenter.y += squareSpeed.y;
  squareAngle += rotationSpeed;

  collide();
}

void collide() {
  dynamicRadius = abs(sin(collisionTheta) * cornerRadiusOffset);

  boolean xCollide = squareCenter.x > width - squareWidth / 2 - dynamicRadius || squareCenter.x < squareWidth / 2 + dynamicRadius;
  boolean yCollide = squareCenter.y > height - squareWidth / 2 - dynamicRadius || squareCenter.y < squareWidth / 2 + dynamicRadius;

  squareSpeed.x *= xCollide ? -1 : 1;
  squareSpeed.y *= yCollide ? -1 : 1;
  rotationSpeed *= xCollide || yCollide ? -1 : 1;

  collisionTheta += rotationSpeed * 2;
}
