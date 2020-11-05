PVector anchor;
PVector[] controls;
boolean isOnControl1, isOnControl2, isOnAnchor;

void setup() {
  size(512, 512);
  anchor = new PVector(generateRandomPoint(),generateRandomPoint());
  controls = new PVector[] {
    new PVector(generateRandomPoint(), generateRandomPoint()),
    new PVector(generateRandomPoint(), generateRandomPoint()),
  };
}

void draw() {
  background(255);
  noFill();
  strokeWeight(4);
  stroke(0);

  beginShape();
  vertex(width / 2, height / 2);
  bezierVertex(
    controls[0].x, controls[0].y,
    controls[1].x, controls[1].y,
    anchor.x, anchor.y
  );
  endShape();

  // Center point
  fill(255, 0, 0);
  strokeWeight(0);
  ellipse(width / 2, width / 2, 10, 10);

  // Connecting lines
  line(controls[0].x, controls[0].y, anchor.x, anchor.y);
  line(controls[1].x, controls[1].y, anchor.x, anchor.y);

  // Control points
  fill(0, 0, 255);
  rect(controls[0].x - 5, controls[0].y - 5, 10, 10);
  rect(controls[1].x - 5, controls[1].y - 5, 10, 10);

  //Anchor points
  fill(127, 0, 255);
  ellipse(anchor.x, anchor.y, 10, 10);

  if(dist(mouseX, mouseY, anchor.x, anchor.y) < 5) {
    isOnAnchor = true;
  } else if(dist(mouseX, mouseY, controls[0].x, controls[0].y) < 5) {
    isOnControl1 = true;
  } else if(dist(mouseX, mouseY, controls[1].x, controls[1].y) < 5) {
    isOnControl2 = true;
  } else {
    isOnAnchor = isOnControl1 = isOnControl2 = false;
  }
}

void mouseDragged() {
  if (isOnAnchor) {
    anchor.x = mouseX;
    anchor.y = mouseY;
  } else if(isOnControl1) {
    controls[0].x = mouseX;
    controls[0].y = mouseY;
  } else if(isOnControl2) {
    controls[1].x = mouseX;
    controls[1].y = mouseY;
  }
}

private float generateRandomPoint() {
  return random(100, width - 100);
}
