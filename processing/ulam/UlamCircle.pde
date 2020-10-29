public class UlamCircle {

  private float particleRadius;
  private float circleRadius;
  private PVector center;
  private ArrayList<Boolean> primes;
  private ArrayList<Particle> particles;

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

    for (float circleRaidus = circleRadius; circleRaidus > particleRadius; circleRaidus -= particleRadius * 2) {
      noFill();
      stroke(255);

      int parts = ceil(PI / asin(particleRadius / circleRaidus));
      float arc = TWO_PI / parts;
      float shade = map(circleRaidus, particleRadius, height / 2.0, 255, 150);

      for (int i = 0; i < parts; i++) {
        float theta = i * arc;
        float x = circleRaidus * cos(theta);
        float y = circleRaidus * sin(theta);

        if(primes.get(primeIndex)) {
          Particle p = particles.get(particleIndex);
          p.setPosition(x, y);
          p.draw();
        }

        primeIndex++;
      }
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
  }
}
