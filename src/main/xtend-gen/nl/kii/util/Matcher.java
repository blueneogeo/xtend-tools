package nl.kii.util;

import nl.kii.util.Opt;

@SuppressWarnings("all")
public interface Matcher<I extends Object, T extends Object> {
  public abstract Opt<T> match(final I instance);
}
