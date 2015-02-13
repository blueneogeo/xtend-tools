package nl.kii.util;

import nl.kii.util.Period;

@SuppressWarnings("all")
public class Hours extends Period {
  public Hours(final long hrs) {
    super((((hrs * 1000) * 60) * 60));
  }
}
