package nl.kii.util;

import com.google.common.base.Objects;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableList.Builder;
import com.google.common.collect.ImmutableSet;
import java.io.Closeable;
import java.io.Serializable;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import nl.kii.util.Err;
import nl.kii.util.Log;
import nl.kii.util.None;
import nl.kii.util.NoneException;
import nl.kii.util.Opt;
import nl.kii.util.Some;
import org.apache.commons.lang.SerializationUtils;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.IteratorExtensions;
import org.eclipse.xtext.xbase.lib.Pair;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.slf4j.Logger;

@SuppressWarnings("all")
public class XtendTools {
  /**
   * Clone an object using serialization. warning, this means it can be very
   * slow compared to normal cloning. Benefit is that it will provide deep cloning
   */
  public static <T extends Serializable> T cloneSerializable(final T object) {
    Object _clone = SerializationUtils.clone(object);
    return ((T) _clone);
  }
  
  /**
   * Perform an operation on a closable, and close it when finished
   */
  public static <I extends Closeable> void using(final I closable, final Procedure1<? super I> fn) {
    try {
      try {
        fn.apply(closable);
      } finally {
        closable.close();
      }
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  /**
   * Perform an operation on a closable, and close it when finished
   */
  public static <I extends Closeable, T extends Object> T using(final I closable, final Function1<? super I,? extends T> fn) {
    try {
      T _xtrycatchfinallyexpression = null;
      try {
        T _apply = fn.apply(closable);
        _xtrycatchfinallyexpression = _apply;
      } finally {
        closable.close();
      }
      return _xtrycatchfinallyexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public static <I extends Closeable, T extends Object> Opt<T> attemptUsing(final I closable, final Function1<? super I,? extends T> fn) {
    Opt<T> _xtrycatchfinallyexpression = null;
    try {
      T _using = XtendTools.<I, T>using(closable, fn);
      Opt<T> _option = XtendTools.<T>option(_using);
      _xtrycatchfinallyexpression = _option;
    } catch (final Throwable _t) {
      if (_t instanceof Throwable) {
        final Throwable e = (Throwable)_t;
        Err<T> _error = XtendTools.<T>error(e);
        _xtrycatchfinallyexpression = _error;
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    return _xtrycatchfinallyexpression;
  }
  
  public static <T extends Object> boolean defined(final Object o) {
    boolean _switchResult = false;
    boolean _matched = false;
    if (!_matched) {
      if (Objects.equal(o,null)) {
        _matched=true;
        _switchResult = false;
      }
    }
    if (!_matched) {
      if (o instanceof None) {
        final None<T> _none = (None<T>)o;
        _matched=true;
        _switchResult = false;
      }
    }
    if (!_matched) {
      if (o instanceof Err) {
        final Err<T> _err = (Err<T>)o;
        _matched=true;
        _switchResult = false;
      }
    }
    if (!_matched) {
      _switchResult = true;
    }
    return _switchResult;
  }
  
  /**
   * saves option importing
   * example: api.getUser(userId).option // if getUser returns null, it will be None, otherwise Some<User>
   */
  public static <T extends Object> Opt<T> option(final T object) {
    Opt<T> _option = Opt.<T>option(object);
    return _option;
  }
  
  public static <T extends Object> Some<T> some(final T object) {
    Some<T> _some = Opt.<T>some(object);
    return _some;
  }
  
  public static <T extends Object> None<T> none() {
    None<T> _none = new None<T>();
    return _none;
  }
  
  public static <T extends Object> Err<T> error(final Throwable t) {
    Err<T> _err = new Err<T>(t);
    return _err;
  }
  
  public static <T extends Object> Err<T> error() {
    Err<T> _err = new Err<T>();
    return _err;
  }
  
  /**
   * wrap a call as an option (exception or null generates none)<p>
   * example: val userOption = attempt [ api.getUser(userId) ] // if API throws exception, return None
   */
  public static <T extends Object> Opt<T> attempt(final Function1<? super Object,? extends T> fn) {
    Opt<T> _xtrycatchfinallyexpression = null;
    try {
      T _apply = fn.apply(null);
      Opt<T> _option = XtendTools.<T>option(_apply);
      _xtrycatchfinallyexpression = _option;
    } catch (final Throwable _t) {
      if (_t instanceof Exception) {
        final Exception e = (Exception)_t;
        Err<T> _error = XtendTools.<T>error(e);
        _xtrycatchfinallyexpression = _error;
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    return _xtrycatchfinallyexpression;
  }
  
  public static <I extends Object, T extends Object> I apply(final I input, final Procedure1<? super I> fn) {
    I _xblockexpression = null;
    {
      fn.apply(input);
      _xblockexpression = (input);
    }
    return _xblockexpression;
  }
  
  /**
   * Same as => but with optional execution and option result<p>
   * example: normally you do: user => [ name = 'john' ]<p>
   * but what if user is of type Option<User><p>
   * then you can do: user.attempt [ name = 'john' ]<br>
   * the assignment will only complete if there was a user
   */
  public static <T extends Object, O extends Object> Opt<O> attempt(final Opt<O> o, final Function1<? super O,? extends T> fn) {
    try {
      Opt<O> _xblockexpression = null;
      {
        boolean _defined = XtendTools.<Object>defined(o);
        if (_defined) {
          O _value = o.value();
          fn.apply(_value);
        }
        _xblockexpression = (o);
      }
      return _xblockexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  /**
   * Same as => but with optional execution and option result
   * example: normally you do: user => [ name = 'john' ]
   * but what if user is of type Option<User>
   * then you can do: user.attempt [ name = 'john' ]
   * the assignment will only complete if there was a user
   * <p>
   * This version also accept functions that have no result
   */
  public static <T extends Object, O extends Object> Opt<O> attempt(final Opt<O> o, final Procedure1<? super O> fn) {
    try {
      Opt<O> _xblockexpression = null;
      {
        boolean _defined = XtendTools.<Object>defined(o);
        if (_defined) {
          O _value = o.value();
          fn.apply(_value);
        }
        _xblockexpression = (o);
      }
      return _xblockexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  /**
   * Transform an option into a new option using a function.
   * The function allows you to transform the value of the passed option,
   * saving you the need to unwrap it yourself
   */
  public static <T extends Object, O extends Object> Opt<T> mapOpt(final Opt<O> o, final Function1<? super O,? extends T> fn) {
    try {
      Opt<T> _xifexpression = null;
      boolean _defined = XtendTools.<Object>defined(o);
      if (_defined) {
        O _value = o.value();
        T _apply = fn.apply(_value);
        Opt<T> _option = XtendTools.<T>option(_apply);
        _xifexpression = _option;
      } else {
        None<T> _none = XtendTools.<T>none();
        _xifexpression = _none;
      }
      return _xifexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  /**
   * conditionally execute a function, and return an option
   * <p>
   * example: val userOption = when(userId) [ api.getUser(userId) ]
   */
  public static <T extends Object, I extends Object> Opt<T> ifTrue(final boolean condition, final Function1<? super Object,? extends T> fn) {
    Opt<T> _xifexpression = null;
    if (condition) {
      T _apply = fn.apply(null);
      Opt<T> _option = XtendTools.<T>option(_apply);
      _xifexpression = _option;
    } else {
      None<T> _none = XtendTools.<T>none();
      _xifexpression = _none;
    }
    return _xifexpression;
  }
  
  public static <T extends Object, I extends Object> Opt<T> ifSome(final Opt<I> o, final Function1<? super I,? extends T> fn) {
    try {
      Opt<T> _xifexpression = null;
      boolean _defined = XtendTools.<Object>defined(o);
      if (_defined) {
        I _value = o.value();
        T _apply = fn.apply(_value);
        Opt<T> _option = XtendTools.<T>option(_apply);
        _xifexpression = _option;
      } else {
        None<T> _none = XtendTools.<T>none();
        _xifexpression = _none;
      }
      return _xifexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public static <T extends Object, I extends Object> Opt<T> ifEmpty(final Opt<I> o, final Function1<? super I,? extends T> fn) {
    try {
      Opt<T> _xifexpression = null;
      boolean _defined = XtendTools.<Object>defined(o);
      boolean _not = (!_defined);
      if (_not) {
        I _value = o.value();
        T _apply = fn.apply(_value);
        Opt<T> _option = XtendTools.<T>option(_apply);
        _xifexpression = _option;
      } else {
        None<T> _none = XtendTools.<T>none();
        _xifexpression = _none;
      }
      return _xifexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public static <T extends Object, I extends Object> Opt<T> ifError(final Opt<I> o, final Function1<? super I,? extends T> fn) {
    try {
      Opt<T> _xifexpression = null;
      boolean _hasError = o.hasError();
      if (_hasError) {
        I _value = o.value();
        T _apply = fn.apply(_value);
        Opt<T> _option = XtendTools.<T>option(_apply);
        _xifexpression = _option;
      } else {
        None<T> _none = XtendTools.<T>none();
        _xifexpression = _none;
      }
      return _xifexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public static <T extends Object> T ifTrue(final T chain, final boolean condition, final Function1<? super T,? extends T> fn) {
    T _xblockexpression = null;
    {
      if (condition) {
        fn.apply(chain);
      }
      _xblockexpression = (chain);
    }
    return _xblockexpression;
  }
  
  public static <T extends Object, V extends Object> T ifSome(final T chain, final Opt<V> o, final Function1<? super T,? extends T> fn) {
    T _xblockexpression = null;
    {
      boolean _defined = XtendTools.<Object>defined(o);
      if (_defined) {
        fn.apply(chain);
      }
      _xblockexpression = (chain);
    }
    return _xblockexpression;
  }
  
  public static <T extends Object, V extends Object> T ifEmpty(final T chain, final Opt<V> o, final Function1<? super T,? extends T> fn) {
    T _xblockexpression = null;
    {
      boolean _defined = XtendTools.<Object>defined(o);
      boolean _not = (!_defined);
      if (_not) {
        fn.apply(chain);
      }
      _xblockexpression = (chain);
    }
    return _xblockexpression;
  }
  
  public static <T extends Object, V extends Object> T ifError(final T chain, final Opt<V> o, final Function1<? super T,? extends T> fn) {
    T _xblockexpression = null;
    {
      boolean _hasError = o.hasError();
      if (_hasError) {
        fn.apply(chain);
      }
      _xblockexpression = (chain);
    }
    return _xblockexpression;
  }
  
  public static <T extends Object> T or(final T o, final T fallback) {
    T _xifexpression = null;
    boolean _defined = XtendTools.<Object>defined(o);
    if (_defined) {
      _xifexpression = o;
    } else {
      _xifexpression = fallback;
    }
    return _xifexpression;
  }
  
  public static <T extends Object> T or(final Opt<T> o, final T fallback) {
    try {
      T _xifexpression = null;
      boolean _defined = XtendTools.<Object>defined(o);
      if (_defined) {
        T _value = o.value();
        _xifexpression = _value;
      } else {
        _xifexpression = fallback;
      }
      return _xifexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public static <T extends Object> T or(final T o, final Function1<? super Object,? extends T> fallbackFn) {
    T _xifexpression = null;
    boolean _defined = XtendTools.<Object>defined(o);
    if (_defined) {
      _xifexpression = o;
    } else {
      T _apply = fallbackFn.apply(null);
      _xifexpression = _apply;
    }
    return _xifexpression;
  }
  
  public static <T extends Object> T or(final Opt<T> o, final Function1<? super Object,? extends T> fallbackFn) {
    try {
      T _xifexpression = null;
      boolean _defined = XtendTools.<Object>defined(o);
      if (_defined) {
        T _value = o.value();
        _xifexpression = _value;
      } else {
        T _apply = fallbackFn.apply(null);
        _xifexpression = _apply;
      }
      return _xifexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public static <T extends Object> T orNull(final T o) {
    T _xifexpression = null;
    boolean _defined = XtendTools.<Object>defined(o);
    if (_defined) {
      _xifexpression = o;
    } else {
      _xifexpression = null;
    }
    return _xifexpression;
  }
  
  public static <T extends Object> T orNull(final Opt<T> o) {
    try {
      T _xifexpression = null;
      boolean _defined = XtendTools.<Object>defined(o);
      if (_defined) {
        T _value = o.value();
        _xifexpression = _value;
      } else {
        _xifexpression = null;
      }
      return _xifexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public static <T extends Object> T orThrow(final Opt<T> o) {
    try {
      T _switchResult = null;
      boolean _matched = false;
      if (!_matched) {
        if (o instanceof Err) {
          final Err<T> _err = (Err<T>)o;
          _matched=true;
          throw _err.getException();
        }
      }
      if (!_matched) {
        if (o instanceof None) {
          final None<T> _none = (None<T>)o;
          _matched=true;
          NoneException _noneException = new NoneException();
          throw _noneException;
        }
      }
      if (!_matched) {
        if (o instanceof Some) {
          final Some<T> _some = (Some<T>)o;
          _matched=true;
          T _value = _some.value();
          _switchResult = _value;
        }
      }
      return _switchResult;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public static <T extends Object> T orThrow(final T o, final Function1<? super Object,? extends Throwable> exceptionFn) {
    try {
      T _xifexpression = null;
      boolean _defined = XtendTools.<Object>defined(o);
      if (_defined) {
        _xifexpression = o;
      } else {
        throw exceptionFn.apply(null);
      }
      return _xifexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public static <T extends Object> T orThrow(final Opt<T> o, final Function1<? super Object,? extends Throwable> exceptionFn) {
    try {
      T _xifexpression = null;
      boolean _defined = XtendTools.<Object>defined(o);
      if (_defined) {
        T _value = o.value();
        _xifexpression = _value;
      } else {
        throw exceptionFn.apply(null);
      }
      return _xifexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public static <T extends Object> boolean in(final T instance, final List<T> objects) {
    boolean _xifexpression = false;
    boolean _and = false;
    boolean _defined = XtendTools.<Object>defined(instance);
    if (!_defined) {
      _and = false;
    } else {
      boolean _defined_1 = XtendTools.<Object>defined(objects);
      _and = (_defined && _defined_1);
    }
    if (_and) {
      boolean _contains = objects.contains(instance);
      _xifexpression = _contains;
    } else {
      _xifexpression = false;
    }
    return _xifexpression;
  }
  
  public static <T extends Object> boolean in(final T instance, final Object... objects) {
    boolean _xifexpression = false;
    boolean _and = false;
    boolean _defined = XtendTools.<Object>defined(instance);
    if (!_defined) {
      _and = false;
    } else {
      boolean _defined_1 = XtendTools.<Object>defined(objects);
      _and = (_defined && _defined_1);
    }
    if (_and) {
      boolean _contains = ((List<Object>)Conversions.doWrapArray(objects)).contains(instance);
      _xifexpression = _contains;
    } else {
      _xifexpression = false;
    }
    return _xifexpression;
  }
  
  public static <T extends Object> List<T> list(final Class<T> cls) {
    LinkedList<T> _newLinkedList = CollectionLiterals.<T>newLinkedList();
    return _newLinkedList;
  }
  
  public static <T extends Object> List<T> list(final T... objects) {
    List<T> _newImmutableList = CollectionLiterals.<T>newImmutableList(objects);
    return _newImmutableList;
  }
  
  public static <T extends Object> Iterable<T> each(final Iterable<T> iterable, final Procedure1<? super T> fn) {
    Iterable<T> _xblockexpression = null;
    {
      IterableExtensions.<T>forEach(iterable, fn);
      _xblockexpression = (iterable);
    }
    return _xblockexpression;
  }
  
  /**
   * Convert a list of options into actual values, filtering out the none and error values.
   * Like filterNull, but then for a list of Options
   */
  public static <T extends Object> Iterable<T> filterEmpty(final Iterable<? extends Opt<T>> iterable) {
    final Function1<Opt<T>,T> _function = new Function1<Opt<T>,T>() {
        public T apply(final Opt<T> it) {
          T _orNull = XtendTools.<T>orNull(it);
          return _orNull;
        }
      };
    Iterable<T> _map = IterableExtensions.map(iterable, _function);
    Iterable<T> _filterNull = IterableExtensions.<T>filterNull(_map);
    return _filterNull;
  }
  
  public static <T extends Object> Iterable<? extends Opt<T>> filterError(final Iterable<? extends Opt<T>> iterable) {
    final Function1<Opt<T>,Boolean> _function = new Function1<Opt<T>,Boolean>() {
        public Boolean apply(final Opt<T> it) {
          boolean _hasError = it.hasError();
          boolean _not = (!_hasError);
          return Boolean.valueOf(_not);
        }
      };
    Iterable<? extends Opt<T>> _filter = IterableExtensions.filter(iterable, _function);
    return _filter;
  }
  
  /**
   * Triggers the passed or function for each error in the list,
   * handy for tracking errors for example:
   * <pre>usersIds.attemptMap [ get user ].onError [ error handling ].filterEmpty</pre>
   */
  public static <T extends Object> Iterable<? extends Opt<T>> onError(final Iterable<? extends Opt<T>> iterable, final Procedure1<? super Err<T>> errorHandler) {
    Iterable<? extends Opt<T>> _xblockexpression = null;
    {
      final Function1<Opt<T>,Boolean> _function = new Function1<Opt<T>,Boolean>() {
          public Boolean apply(final Opt<T> it) {
            boolean _hasError = it.hasError();
            return Boolean.valueOf(_hasError);
          }
        };
      Iterable<? extends Opt<T>> _filter = IterableExtensions.filter(iterable, _function);
      final Procedure1<Opt<T>> _function_1 = new Procedure1<Opt<T>>() {
          public void apply(final Opt<T> it) {
            errorHandler.apply(((Err<T>) it));
          }
        };
      XtendTools.each(_filter, _function_1);
      _xblockexpression = (iterable);
    }
    return _xblockexpression;
  }
  
  /**
   * Triggers the passed or function for each none in the list,
   * handy for tracking empty results, for example:
   * <pre>usersIds.map [ get user ].onNone [ println('could not find user') ].filterNone</pre>
   */
  public static <T extends Object> Iterable<? extends Opt<T>> onNone(final Iterable<? extends Opt<T>> iterable, final Procedure1<? super None<T>> noneHandler) {
    Iterable<? extends Opt<T>> _xblockexpression = null;
    {
      final Function1<Opt<T>,Boolean> _function = new Function1<Opt<T>,Boolean>() {
          public Boolean apply(final Opt<T> it) {
            boolean _hasNone = it.hasNone();
            return Boolean.valueOf(_hasNone);
          }
        };
      Iterable<? extends Opt<T>> _filter = IterableExtensions.filter(iterable, _function);
      final Procedure1<Opt<T>> _function_1 = new Procedure1<Opt<T>>() {
          public void apply(final Opt<T> it) {
            noneHandler.apply(((None<T>) it));
          }
        };
      XtendTools.each(_filter, _function_1);
      _xblockexpression = (iterable);
    }
    return _xblockexpression;
  }
  
  /**
   * Remove all double values in a list, turning it into a list of unique values
   */
  public static <T extends Object> Iterable<T> distinct(final Iterable<T> values) {
    final Function1<T,T> _function = new Function1<T,T>() {
        public T apply(final T it) {
          return it;
        }
      };
    Map<T,List<T>> _groupBy = XtendTools.<T, T>groupBy(values, _function);
    Iterable<Pair<T,List<T>>> _pairs = XtendTools.<T, List<T>>toPairs(_groupBy);
    final Function1<Pair<T,List<T>>,T> _function_1 = new Function1<Pair<T,List<T>>,T>() {
        public T apply(final Pair<T,List<T>> it) {
          List<T> _value = it.getValue();
          T _head = IterableExtensions.<T>head(_value);
          return _head;
        }
      };
    Iterable<T> _map = IterableExtensions.<Pair<T,List<T>>, T>map(_pairs, _function_1);
    return _map;
  }
  
  /**
   * Always returns an immutable list, even if a null result is passed. handy when chaining, eliminates null checks
   * <pre>example: getUsers.filter[age>20].list</pre>
   */
  public static <T extends Object> List<T> toList(final Iterable<T> iterable) {
    List<T> _xifexpression = null;
    boolean _defined = XtendTools.<Object>defined(iterable);
    boolean _not = (!_defined);
    if (_not) {
      List<T> _newImmutableList = CollectionLiterals.<T>newImmutableList();
      _xifexpression = _newImmutableList;
    } else {
      Iterator<T> _iterator = iterable.iterator();
      List<T> _list = IteratorExtensions.<T>toList(_iterator);
      List<T> _immutableCopy = ImmutableList.<T>copyOf(_list);
      _xifexpression = _immutableCopy;
    }
    return _xifexpression;
  }
  
  /**
   * Always returns an immutable set, even if a null result was passed. handy when chaining, eliminates null checks.
   * note: double values will be removed!
   */
  public static <T extends Object> Set<T> toSet(final Iterable<T> iterable) {
    Set<T> _xifexpression = null;
    boolean _defined = XtendTools.<Object>defined(iterable);
    boolean _not = (!_defined);
    if (_not) {
      HashSet<T> _newHashSet = CollectionLiterals.<T>newHashSet();
      _xifexpression = _newHashSet;
    } else {
      Set<T> _xblockexpression = null;
      {
        Iterable<T> _distinct = XtendTools.<T>distinct(iterable);
        final List<T> uniques = XtendTools.<T>toList(_distinct);
        HashSet<T> _hashSet = new HashSet<T>(uniques);
        Set<T> _immutableCopy = ImmutableSet.<T>copyOf(_hashSet);
        _xblockexpression = (_immutableCopy);
      }
      _xifexpression = _xblockexpression;
    }
    return _xifexpression;
  }
  
  public static <K extends Object, V extends Object> Iterable<Pair<K,V>> toPairs(final Map<K,V> map) {
    Set<Entry<K,V>> _entrySet = map.entrySet();
    final Function1<Entry<K,V>,Pair<K,V>> _function = new Function1<Entry<K,V>,Pair<K,V>>() {
        public Pair<K,V> apply(final Entry<K,V> it) {
          K _key = it.getKey();
          V _value = it.getValue();
          Pair<K,V> _mappedTo = Pair.<K, V>of(_key, _value);
          return _mappedTo;
        }
      };
    Iterable<Pair<K,V>> _map = IterableExtensions.<Entry<K,V>, Pair<K,V>>map(_entrySet, _function);
    return _map;
  }
  
  public static <K extends Object, V extends Object> Map<K,V> toMap(final Iterable<Pair<K,V>> pairs) {
    HashMap<K,V> _xblockexpression = null;
    {
      final HashMap<K,V> map = CollectionLiterals.<K, V>newHashMap();
      boolean _defined = XtendTools.<Object>defined(pairs);
      if (_defined) {
        final Procedure1<Pair<K,V>> _function = new Procedure1<Pair<K,V>>() {
            public void apply(final Pair<K,V> it) {
              K _key = it.getKey();
              V _value = it.getValue();
              map.put(_key, _value);
            }
          };
        IterableExtensions.<Pair<K,V>>forEach(pairs, _function);
      }
      _xblockexpression = (map);
    }
    return _xblockexpression;
  }
  
  public static <K extends Object, V extends Object> Map<K,List<V>> groupBy(final Iterable<V> list, final Function1<? super V,? extends K> indexFn) {
    HashMap<K,List<V>> _xblockexpression = null;
    {
      HashMap<K,List<V>> _hashMap = new HashMap<K,List<V>>();
      final HashMap<K,List<V>> map = _hashMap;
      final Procedure1<V> _function = new Procedure1<V>() {
          public void apply(final V it) {
            final K index = indexFn.apply(it);
            boolean _containsKey = map.containsKey(index);
            if (_containsKey) {
              final List<V> values = map.get(index);
              values.add(it);
            } else {
              final LinkedList<V> values_1 = CollectionLiterals.<V>newLinkedList(it);
              map.put(index, values_1);
            }
          }
        };
      IterableExtensions.<V>forEach(list, _function);
      _xblockexpression = (map);
    }
    return _xblockexpression;
  }
  
  public static <V extends Object> Map<V,Integer> count(final Iterable<V> values) {
    final Function1<V,V> _function = new Function1<V,V>() {
        public V apply(final V it) {
          return it;
        }
      };
    Map<V,Integer> _countBy = XtendTools.<V, V>countBy(values, _function);
    return _countBy;
  }
  
  public static <K extends Object, V extends Object> Map<V,Integer> countBy(final Iterable<V> values, final Function1<? super V,? extends K> indexFn) {
    Map<K,List<V>> _groupBy = XtendTools.<K, V>groupBy(values, indexFn);
    Iterable<Pair<K,List<V>>> _pairs = XtendTools.<K, List<V>>toPairs(_groupBy);
    final Function1<Pair<K,List<V>>,Pair<V,Integer>> _function = new Function1<Pair<K,List<V>>,Pair<V,Integer>>() {
        public Pair<V,Integer> apply(final Pair<K,List<V>> it) {
          List<V> _value = it.getValue();
          V _head = IterableExtensions.<V>head(_value);
          List<V> _value_1 = it.getValue();
          int _size = _value_1.size();
          Pair<V,Integer> _mappedTo = Pair.<V, Integer>of(_head, Integer.valueOf(_size));
          return _mappedTo;
        }
      };
    Iterable<Pair<V,Integer>> _map = IterableExtensions.<Pair<K,List<V>>, Pair<V,Integer>>map(_pairs, _function);
    Map<V,Integer> _map_1 = XtendTools.<V, Integer>toMap(_map);
    return _map_1;
  }
  
  public static <K extends Object, V extends Object> Map<K,V> index(final Iterable<V> iterable, final Function1<? super V,? extends K> indexFn) {
    final Function1<V,K> _function = new Function1<V,K>() {
        public K apply(final V it) {
          K _apply = indexFn.apply(it);
          return _apply;
        }
      };
    Map<K,V> _map = IterableExtensions.<K, V>toMap(iterable, _function);
    return _map;
  }
  
  public static <T extends Object, R extends Object> Iterable<Opt<R>> mapOpt(final Iterable<Opt<T>> iterable, final Function1<? super T,? extends R> fn) {
    final Function1<Opt<T>,Opt<R>> _function = new Function1<Opt<T>,Opt<R>>() {
        public Opt<R> apply(final Opt<T> it) {
          Opt<R> _mapOpt = XtendTools.<R, T>mapOpt(it, fn);
          return _mapOpt;
        }
      };
    Iterable<Opt<R>> _map = IterableExtensions.<Opt<T>, Opt<R>>map(iterable, _function);
    return _map;
  }
  
  public static <T extends Object, R extends Object> Iterable<Opt<R>> attemptMap(final Iterable<T> iterable, final Function1<? super T,? extends R> fn) {
    final Function1<T,Opt<R>> _function = new Function1<T,Opt<R>>() {
        public Opt<R> apply(final T it) {
          Opt<R> _xblockexpression = null;
          {
            final T o = it;
            final Function1<Object,R> _function = new Function1<Object,R>() {
                public R apply(final Object it) {
                  R _apply = fn.apply(o);
                  return _apply;
                }
              };
            Opt<R> _attempt = XtendTools.<R>attempt(_function);
            _xblockexpression = (_attempt);
          }
          return _xblockexpression;
        }
      };
    Iterable<Opt<R>> _map = IterableExtensions.<T, Opt<R>>map(iterable, _function);
    return _map;
  }
  
  public static <T extends Number> double sum(final Iterable<T> values) {
    double _xblockexpression = (double) 0;
    {
      double total = 0;
      for (final T value : values) {
        double _doubleValue = value.doubleValue();
        double _plus = (total + _doubleValue);
        total = _plus;
      }
      _xblockexpression = (total);
    }
    return _xblockexpression;
  }
  
  public static <T extends Number> double average(final Iterable<T> values) {
    double _sum = XtendTools.<T>sum(values);
    int _length = ((Object[])Conversions.unwrapArray(values, Object.class)).length;
    double _divide = (_sum / _length);
    return _divide;
  }
  
  public static Log wrapper(final Logger logger) {
    Log _log = new Log(logger, null);
    return _log;
  }
  
  public static Log wrapper(final Logger logger, final String name) {
    Log _log = new Log(logger, name);
    return _log;
  }
  
  public static Object print(final Object o) {
    Object _println = InputOutput.<Object>println(o);
    return _println;
  }
  
  public static void print(final Object... o) {
    final Procedure1<Object> _function = new Procedure1<Object>() {
        public void apply(final Object it) {
          InputOutput.<Object>println(it);
        }
      };
    IterableExtensions.<Object>forEach(((Iterable<Object>)Conversions.doWrapArray(o)), _function);
  }
  
  public static <T extends Object> T print(final Function0<? extends T> o) {
    T _apply = o.apply();
    T _println = InputOutput.<T>println(_apply);
    return _println;
  }
  
  public static <T extends Object> Object print(final Function1<? super Object,? extends T> o) {
    T _apply = o.apply(null);
    Object _print = XtendTools.print(_apply);
    return _print;
  }
  
  public static <T extends Object> void assertNone(final Opt<T> option) {
    boolean _hasSome = option.hasSome();
    Assert.assertFalse(_hasSome);
  }
  
  public static <T extends Object> void assertSome(final Opt<T> option) {
    boolean _hasSome = option.hasSome();
    Assert.assertTrue(_hasSome);
  }
  
  public static <T extends Object> void assertSome(final Opt<T> option, final T value) {
    try {
      XtendTools.<T>assertSome(option);
      T _value = option.value();
      Assert.assertEquals(value, _value);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public static <T extends Object> ImmutableList<T> addSafe(final List<T> list, final T value) {
    Builder<T> _builder = ImmutableList.<T>builder();
    Builder<T> _addAll = _builder.addAll(list);
    Builder<T> _add = _addAll.add(value);
    ImmutableList<T> _build = _add.build();
    return _build;
  }
  
  public static <T extends Object> ImmutableSet<T> addSafe(final Set<T> set, final T value) {
    com.google.common.collect.ImmutableSet.Builder<T> _builder = ImmutableSet.<T>builder();
    com.google.common.collect.ImmutableSet.Builder<T> _addAll = _builder.addAll(set);
    com.google.common.collect.ImmutableSet.Builder<T> _add = _addAll.add(value);
    ImmutableSet<T> _build = _add.build();
    return _build;
  }
}
