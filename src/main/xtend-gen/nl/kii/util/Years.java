package nl.kii.util;

import nl.kii.util.Period;

@SuppressWarnings("all")
public class Years extends Period {
  public Years(final long years) {
    super((((((years * 1000) * 60) * 60) * 24) * 365));
  }
}
