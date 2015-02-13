package nl.kii.util;

import nl.kii.util.Period;

@SuppressWarnings("all")
public class Minutes extends Period {
  public Minutes(final long mins) {
    super(((mins * 1000) * 60));
  }
}
