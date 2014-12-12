package nl.kii.util;

import nl.kii.util.Matcher;
import nl.kii.util.Opt;

@SuppressWarnings("all")
public class InstanceMatcher<T extends java.lang.Object> /* implements Matcher<Object, T>  */{
  private /* type is 'null' */ types;
  
  public InstanceMatcher(final /* Class<? extends T> */Object... types) {
    this.types = types;
  }
  
  public Opt<T> match(final /* Object */Object instance) {
    throw new Error("Unresolved compilation problems:"
      + "\nisAssignableFrom cannot be resolved");
  }
}
