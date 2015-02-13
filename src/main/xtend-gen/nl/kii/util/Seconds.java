package nl.kii.util;

import nl.kii.util.Period;

@SuppressWarnings("all")
public class Seconds extends Period {
  public Seconds(final long secs) {
    super((secs * 1000));
  }
}
