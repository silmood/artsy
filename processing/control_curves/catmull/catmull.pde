int anchorsCount;
PVector[] anchors;
boolean[] isOnAnchor;
float anchorOffset;
float radius;

void setup() {
  size(768, 768);
  radius = 5;
  anchorsCount = floor(random(4, 8));
  anchors = generateAnchors(anchorsCount, width / 4,  3 * (width / 4));
  isOnAnchor = generateAnchorsFlags(anchorsCount);
}

void draw() {
  background(0);
  noFill();
  strokeWeight(4);
  stroke(255);

  float curvature = map(mouseX, 0, width, -3, 3);
  curveTightness(curvature);

  drawCurve();
  drawAnchors();
  detectFlags();
}

void drawCurve() {
  beginShape();

  // Catmull-Rom splines 
  // Every point along the curve needs two 
  // additional points  to act as controls
  for (int i = 0; i < anchorsCount; ++i) {
    curveVertex(anchors[i].x, anchors[i].y);
    curveVertex(anchors[i].x, anchors[i].y);
  }

  endShape();
}

void drawAnchors() {
  noStroke();

  for (int i = 0; i < anchorsCount; ++i) {
    ellipseMode(CENTER);
    color c = isOnAnchor[i] ? color(255, 127, 0) : color(0, 127, 255);
    fill(c);
    ellipse(anchors[i].x, anchors[i].y, 8, 8);
  }
}

void detectFlags() {
  for (int i = 0; i < anchorsCount; ++i) {
    isOnAnchor[i] = dist(mouseX, mouseY, anchors[i].x, anchors[i].y) < 8;
  }
}

PVector[] generateAnchors(int count, float min, float max) {
  PVector[] anchors = new PVector[count];

  for (int i = 0; i < count; ++i) {
    float x = random(min, max);
    float y = random(min, max);
    anchors[i] = new PVector(x, y);
  }

  return anchors;
}

boolean[] generateAnchorsFlags(int anchorsCount) {
  boolean[] anchorsFlags = new boolean[anchorsCount];
  for (int i = 0; i < anchorsCount; ++i) {
    anchorsFlags[i] = false;
  }

  return anchorsFlags;
}

void mouseDragged() {
  for (int i = 0; i < anchorsCount; ++i) {
    if(isOnAnchor[i]) {
      anchors[i].x = mouseX;
      anchors[i].y = mouseY;
      break;
    }

  }
}

void mousePressed() {
  //anchors = generateAnchors(anchorsCount, width / 4,  3 * (width / 4));
}
