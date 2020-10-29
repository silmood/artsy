public class UlamSpiral {

  public void draw() {
    float particleRadius = 1;
    ArrayList<Boolean> primes = calcPrimes(particleRadius);

    pushMatrix();
    translate(width / 2, height / 2);
    ellipseMode(RADIUS);
    
    int primeIndex = 0;

    for (float spiralRadius = height / 2.0; spiralRadius > particleRadius; spiralRadius -= particleRadius * 2) {
      noFill();
      stroke(255);

      int parts = ceil(PI / asin(particleRadius / spiralRadius));
      float arc = TWO_PI / parts;
      float shade = map(spiralRadius, particleRadius, height / 2.0, 255, 150);

      for (int i = 0; i < parts; i++) {
        float theta = i * arc;
        float x = spiralRadius * cos(theta);
        float y = spiralRadius * sin(theta);

        if(primes.get(primeIndex)) {
          noStroke();
          fill(shade);
          ellipse(x, y, particleRadius, particleRadius);
        }

        primeIndex++;
      }
    }

    popMatrix();
  }

  private ArrayList<Boolean> calcPrimes(float particleRadius) {
    int count = 0;
    for (float spiralRadius = height / 2.0; spiralRadius > particleRadius; spiralRadius -= particleRadius * 2) {
      count += ceil(PI / asin(particleRadius / spiralRadius));
    }

    return EratosCalc.calcPrimes(count);
  }
}
