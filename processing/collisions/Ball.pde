public class Ball {

  PVector box;
  PVector position;
  PVector oldPosition;
  PVector nudge;
  color c;
  float radius;

  public Ball (float x, float y, float radius, color c, PVector box) {
    position = new PVector(x, y);
    oldPosition = position.get();
    this.box = box;
    this.c = c;
    this.radius = radius;

    nudge = new PVector(random(1, 5), random(1, 5));
    position.add(nudge);
  }

  public Ball (float radius, color c, PVector box) {
    this(random(box.x), random(box.y), radius, c, box);
  }

  public Ball (PVector box) {
    this(random(box.x), random(box.y), 25, color(255, 0, 0), box);
  }

  public void draw() {
    noStroke();
    fill(c);
    ellipse(position.x, position.y, radius * 2, radius * 2);
  }

  public void move() {
    PVector temp = position.get();
    position.x += (position.x - oldPosition.x);
    position.y += (position.y - oldPosition.y);

    oldPosition.set(temp);
    bounce();
  }

  private void bounce() {
    if (position.x <= radius) {
      position.x = radius;
      oldPosition.x = position.x;
      position.x += nudge.x;
    }
    else if (position.x >= (box.x - radius)) {
      position.x = box.x - radius;
      oldPosition.x = position.x;
      position.x -= nudge.x;
    }
    if (position.y <= radius) {
      position.y = radius;
      oldPosition.y = position.y;
      position.y += nudge.y;
    }
    else if (position.y >= (box.y - radius)) {
      position.y = box.y - radius;
      oldPosition.y = position.y;
      position.y -= nudge.y;
    }
  }

}
