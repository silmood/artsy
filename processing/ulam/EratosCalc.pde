import java.util.*;

public static class EratosCalc {

  public static ArrayList<Boolean> calcPrimes(int limit) {
    ArrayList<Boolean> primes = new ArrayList<Boolean>(Collections.nCopies(limit, true));
    for (int i = 2; i < sqrt(limit); i++) {
      if (primes.get(i)) {
        for (int j = i * i; j < limit; j += i) {
          primes.set(j, false);
        }
      }
    }

    return primes;
  }


}
