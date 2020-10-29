public class Particle {

  private float radius;
  private PVector position;
  private color c;

  private Particle(float radius) {
    this.radius = radius;
    position = new PVector(0, 0);
    c = color(random(0, 255));
  }

  public void setPosition(float x, float y) {
    position.x = x;
    position.y = y;
  }

  public void draw() {
    noStroke();
    fill(c);
    ellipse(position.x, position.y, radius, radius);
  }
}
