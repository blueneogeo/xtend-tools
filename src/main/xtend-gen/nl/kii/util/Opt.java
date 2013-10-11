package nl.kii.util;

import nl.kii.util.Err;
import nl.kii.util.None;
import nl.kii.util.NoneException;
import nl.kii.util.Some;
import nl.kii.util.XtendTools;

@SuppressWarnings("all")
public abstract class Opt<T extends Object> implements Iterable<T> {
  public static <T extends Object> Opt<T> option(final T value) {
    Opt<T> _xifexpression = null;
    boolean _defined = XtendTools.<Object>defined(value);
    if (_defined) {
      Some<T> _some = Opt.<T>some(value);
      _xifexpression = _some;
    } else {
      None<T> _none = Opt.<T>none();
      _xifexpression = _none;
    }
    return _xifexpression;
  }
  
  public static <T extends Object> Opt<T> of(final T value) {
    Opt<T> _option = Opt.<T>option(value);
    return _option;
  }
  
  public static <T extends Object> Some<T> some(final T value) {
    Some<T> _some = new Some<T>(value);
    return _some;
  }
  
  public static <T extends Object> None<T> none() {
    None<T> _none = new None<T>();
    return _none;
  }
  
  public static <T extends Object> Err<T> error() {
    Err<T> _err = new Err<T>();
    return _err;
  }
  
  public static <T extends Object> Err<T> error(final Throwable t) {
    Err<T> _err = new Err<T>(t);
    return _err;
  }
  
  public abstract T value() throws NoneException;
  
  public abstract boolean hasSome();
  
  public abstract boolean hasNone();
  
  public abstract boolean hasError();
}
