public class Box {
  private Ball[] balls;
  private PVector position;
  private PVector size;

  public Box (float x, float y, float w, float h, int ballsCount) {
    this.position = new PVector(x, y);
    this.size = new PVector(w, h);
    balls = generateBalls(ballsCount);
  }

  public void draw() {
    pushMatrix();
    translate(position.x, position.y);    

    fill(5, 15, 92);
    strokeWeight(2);
    stroke(166, 105, 156);
    rect(0, 0, size.x, size.y);
    noStroke();

    drawBalls();
    popMatrix();
  }
  
  private void drawBalls() {
    for (Ball ball : balls) {
      ball.draw();
      ball.move();
    }
  }

  private Ball[] generateBalls(int ballsCount) {
    Ball[] balls = new Ball[ballsCount];

    for (int i = 0; i < ballsCount; ++i) {
      balls[i] = new Ball(random(1, 5), color(229, 32, 229), size);
    }

    return balls;
  }

}
