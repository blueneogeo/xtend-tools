package nl.kii.util;

import java.math.BigInteger;
import java.security.SecureRandom;

@SuppressWarnings("all")
public class RandomIDGenerator {
  private final SecureRandom random = new SecureRandom();
  
  public String nextSessionId() {
    BigInteger _bigInteger = new BigInteger(130, this.random);
    return _bigInteger.toString(32);
  }
}
