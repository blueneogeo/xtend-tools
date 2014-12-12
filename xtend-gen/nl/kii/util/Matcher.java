package nl.kii.util;

import nl.kii.util.Opt;

@SuppressWarnings("all")
public interface Matcher<I extends java.lang.Object, T extends java.lang.Object> {
  public abstract Opt<T> match(final I instance);
}
