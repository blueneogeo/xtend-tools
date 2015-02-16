package nl.kii.util;

import nl.kii.util.Matcher;
import nl.kii.util.None;
import nl.kii.util.Opt;
import nl.kii.util.OptExtensions;

@SuppressWarnings("all")
public class InstanceMatcher<T extends Object> implements Matcher<Object, T> {
  private Class<? extends T>[] types;
  
  public InstanceMatcher(final Class<? extends T>... types) {
    this.types = types;
  }
  
  public Opt<T> match(final Object instance) {
    None<T> _xblockexpression = null;
    {
      for (final Class<? extends T> type : this.types) {
        boolean _isAssignableFrom = type.isAssignableFrom(type);
        if (_isAssignableFrom) {
          return OptExtensions.<T>some(((T) instance));
        }
      }
      _xblockexpression = OptExtensions.<T>none();
    }
    return _xblockexpression;
  }
}
