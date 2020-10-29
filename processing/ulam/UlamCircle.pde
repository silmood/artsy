public class UlamCircle {

  private float particleRadius;
  private float circleRadius;
  private PVector center;
  private ArrayList<Boolean> primes;
  private ArrayList<Particle> particles;

  static final float ROTATION_SPEED = PI / 180;
  static final float SHADE_SPEED = PI / 60;

  public UlamCircle(float particleRadius, float circleRadius, PVector center) {
    this.particleRadius = particleRadius;
    this.circleRadius = circleRadius;
    this.center = center;
    generatePrimes();
    generateParticles();
  }

  public void draw() {
    pushMatrix();
    translate(center.x, center.y);
    ellipseMode(RADIUS);
    
    int primeIndex = 0;
    int particleIndex = 0;
    int ringCount = 1;
    color from = color(214, 134, 254);
    color to = color(5, 252, 237);

    for (float radius = particleRadius * 4; radius < circleRadius; radius += particleRadius * 2) {
      int parts = ceil(PI / asin(particleRadius / radius));
      float arc = TWO_PI / parts;
      float percentage = map(radius, particleRadius * 4, circleRadius, 0.0, 1.0);

      color shadeFrom = lerpColor(from, to, sin(frameCount * SHADE_SPEED));
      color shadeTo = lerpColor(from, to, cos(frameCount * SHADE_SPEED));

      color shade = lerpColor(shadeFrom, shadeTo, percentage);

      for (int i = 0; i < parts; i++) {
        float theta = (i * arc) + ( ringCount % 2 == 0 ? frameCount * ROTATION_SPEED : -frameCount * ROTATION_SPEED);
        float x = radius * cos(theta);
        float y = radius * sin(theta);

        if(primes.get(primeIndex)) {
          Particle p = particles.get(particleIndex);
          p.setShade(shade);
          p.setPosition(x, y);
          p.draw();
        }

        primeIndex++;
      }
      ringCount++;
    }

    popMatrix();
  }

  private void generatePrimes() {
    int count = 0;
    for (float circleRaidus = circleRadius; circleRaidus > particleRadius; circleRaidus -= particleRadius * 2) {
      count += ceil(PI / asin(particleRadius / circleRaidus));
    }

    this.primes = EratosCalc.calcPrimes(count);
  }

  private void generateParticles() {
    this.particles = new ArrayList<Particle>();

    for (Boolean isPrime : primes) {
      particles.add(new Particle(particleRadius));
    }

    println("Primes count: " + this.particles.size());
  }
}
