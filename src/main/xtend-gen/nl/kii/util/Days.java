package nl.kii.util;

import nl.kii.util.Period;

@SuppressWarnings("all")
public class Days extends Period {
  public Days(final long days) {
    super(((((days * 1000) * 60) * 60) * 24));
  }
}
