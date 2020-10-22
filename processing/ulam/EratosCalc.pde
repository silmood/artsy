import java.util.*;

public static class EratosCalc {

  public static ArrayList<Boolean> calcPrimes(int limit) {
    ArrayList<Boolean> primes = new ArrayList<Boolean>(Collections.nCopies(limit, true));
    for (int i = 2; i < sqrt(limit); i++) {
      if (primes.get(i)) {
        for (int j = i * i, multiple = 0; j < limit; j += multiple * i) {
          primes.set(j, false);
          multiple++;
        }
      }
    }

    return primes;
  }


}
