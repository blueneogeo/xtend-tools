package nl.kii.util;

import com.google.common.base.CaseFormat;
import com.google.common.base.Objects;

@SuppressWarnings("all")
public class StringExtensions {
  public static String changeCase(final String name, final CaseFormat from, final CaseFormat to) {
    return from.to(to, name);
  }
  
  public static String limit(final String string, final int maxLength) {
    String _xblockexpression = null;
    {
      boolean _or = false;
      boolean _equals = Objects.equal(string, null);
      if (_equals) {
        _or = true;
      } else {
        int _length = string.length();
        boolean _lessEqualsThan = (_length <= maxLength);
        _or = _lessEqualsThan;
      }
      if (_or) {
        return string;
      }
      _xblockexpression = string.substring(0, maxLength);
    }
    return _xblockexpression;
  }
}
