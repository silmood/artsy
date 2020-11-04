float ax, ay, cx, cy;
boolean isOnControl, isOnAnchor;
float radius = 5;

void setup() {
  size(512, 512);

  cx = random(100, width - 100);
  cy = random(100, width - 100);
  ax = random(100, width - 100);
  ay = random(100, width - 100);
}

void draw() {
  background(255);
  noFill();
  strokeWeight(4);
  stroke(0);

  // Curve
  beginShape();
  vertex(width / 2, height / 2);
  quadraticVertex(cx, cy, ax, ay);
  endShape();

  // Center point
  fill(200);
  strokeWeight(1);
  ellipse(width / 2, height / 2, radius, radius);

  // Connecting handle
  line(cx, cy, ax, ay);

  // Control point
  fill(0, 0, 255);
  rect(cx - radius, cy - radius, radius * 2, radius * 2);

  // Anchor point
  fill(255, 127, 0);
  ellipse(ax, ay, radius * 2, radius * 2);

  if (dist(mouseX, mouseY, ax, ay) < radius) {
    isOnAnchor = true;
  } else if (dist(mouseX, mouseY, cx, cy) < radius) {
    isOnControl = true;
  } else {
    isOnAnchor = isOnControl = false;
  }
}

void mouseDragged() {
  if (isOnControl) {
    cx = mouseX;
    cy = mouseY;
  } else if (isOnAnchor) {
    ax = mouseX;
    ay = mouseY;
  }
}
