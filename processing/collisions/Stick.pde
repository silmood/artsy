class Stick {
  Ball b1, b2;
  float r;

  Stick(Ball b1, Ball b2) {
    this.b1 = b1;
    this.b2 = b2;
    r = b1.position.dist(b2.position);
  }

  void draw() {
    b1.draw();
    b2.draw();

    stroke(0);
    strokeWeight(5);

    line(b1.position.x, b1.position.y, b2.position.x, b2.position.y);
  }

  void update() {
    b1.move();
    b2.move();
    constrainLength();
  }

  void constrainLength() {
    float k = 0.1;
    PVector delta = PVector.sub(b2.position, b1.position);

    float deltaLength = delta.mag();
    float d = ((deltaLength - r) / deltaLength);

    b1.position.x += delta.x * k * d/2;
    b1.position.y += delta.y * k * d/2;

    b2.position.x -= delta.x * k * d/2;
    b2.position.y -= delta.y * k * d/2;
  }
}
