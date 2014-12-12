package nl.kii.util;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import nl.kii.util.CloseableExtensions;
import nl.kii.util.Err;
import nl.kii.util.IterableExtensions;
import nl.kii.util.Log;
import nl.kii.util.LogExtensions;
import nl.kii.util.None;
import nl.kii.util.Opt;
import nl.kii.util.OptExtensions;
import nl.kii.util.Readable;
import nl.kii.util.Some;
import nl.kii.util.User;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Pair;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.junit.Test;
import org.slf4j.LoggerFactory;

@SuppressWarnings("all")
public class TestXtendTools {
  @Extension
  private Log logger = LogExtensions.wrapper(LoggerFactory.getLogger(this.getClass()));
  
  public void loadUser(final long userId, final Procedure1<? super String> onLoad) {
    try {
      Thread.sleep(3000);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("user-");
      _builder.append(userId, "");
      String _string = _builder.toString();
      onLoad.apply(_string);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testAttempt() {
    final Function1<Object, None<Object>> _function = new Function1<Object, None<Object>>() {
      public None<Object> apply(final Object it) {
        return OptExtensions.<Object>none();
      }
    };
    Opt<None<Object>> _attempt = OptExtensions.<None<Object>>attempt(_function);
    OptExtensions.<None<Object>>assertNone(_attempt);
    final Function1<TestXtendTools, Object> _function_1 = new Function1<TestXtendTools, Object>() {
      public Object apply(final TestXtendTools it) {
        try {
          throw new Exception();
        } catch (Throwable _e) {
          throw Exceptions.sneakyThrow(_e);
        }
      }
    };
    Opt<Object> _attempt_1 = OptExtensions.<TestXtendTools, Object>attempt(this, _function_1);
    OptExtensions.<Object>assertNone(_attempt_1);
    final Function1<Object, String> _function_2 = new Function1<Object, String>() {
      public String apply(final Object it) {
        return "hello";
      }
    };
    Opt<String> _attempt_2 = OptExtensions.<String>attempt(_function_2);
    OptExtensions.<String>assertSome(_attempt_2, "hello");
  }
  
  @Test
  public void testIfValue() {
    final Function1<Object, String> _function = new Function1<Object, String>() {
      public String apply(final Object it) {
        return "hello";
      }
    };
    Opt<String> _ifTrue = OptExtensions.<String, Object>ifTrue(true, _function);
    OptExtensions.<String>assertSome(_ifTrue, "hello");
    final Function1<Object, String> _function_1 = new Function1<Object, String>() {
      public String apply(final Object it) {
        return "hello";
      }
    };
    Opt<String> _ifTrue_1 = OptExtensions.<String, Object>ifTrue(false, _function_1);
    OptExtensions.<String>assertNone(_ifTrue_1);
    Some<String> _some = OptExtensions.<String>some("test");
    final Function1<String, String> _function_2 = new Function1<String, String>() {
      public String apply(final String it) {
        return "hello";
      }
    };
    Opt<String> _ifSome = OptExtensions.<String, String>ifSome(_some, _function_2);
    OptExtensions.<String>assertSome(_ifSome, "hello");
    None<Object> _none = OptExtensions.<Object>none();
    final Function1<Object, String> _function_3 = new Function1<Object, String>() {
      public String apply(final Object it) {
        return "hello";
      }
    };
    Opt<String> _ifSome_1 = OptExtensions.<String, Object>ifSome(_none, _function_3);
    OptExtensions.<String>assertNone(_ifSome_1);
  }
  
  @Test
  public void testOr() {
    Some<String> _some = OptExtensions.<String>some("hi");
    String _or = OptExtensions.<String>or(_some, "hello");
    Assert.assertEquals(_or, "hi");
    None<String> _none = OptExtensions.<String>none();
    String _or_1 = OptExtensions.<String>or(_none, "hello");
    Assert.assertEquals(_or_1, "hello");
    Some<String> _some_1 = OptExtensions.<String>some("hi");
    final Function1<Object, String> _function = new Function1<Object, String>() {
      public String apply(final Object it) {
        return ("a" + "b");
      }
    };
    String _or_2 = OptExtensions.<String>or(_some_1, _function);
    Assert.assertEquals(_or_2, "hi");
    None<String> _none_1 = OptExtensions.<String>none();
    final Function1<Object, String> _function_1 = new Function1<Object, String>() {
      public String apply(final Object it) {
        return ("a" + "b");
      }
    };
    String _or_3 = OptExtensions.<String>or(_none_1, _function_1);
    Assert.assertEquals(_or_3, "ab");
    try {
      Some<String> _some_2 = OptExtensions.<String>some("hi");
      final Function1<Object, Throwable> _function_2 = new Function1<Object, Throwable>() {
        public Throwable apply(final Object it) {
          return new Exception();
        }
      };
      OptExtensions.<String>orThrow(_some_2, _function_2);
    } catch (final Throwable _t) {
      if (_t instanceof Exception) {
        final Exception c = (Exception)_t;
        OptExtensions.<String>assertSome(
          OptExtensions.<String>some("hello"), "hi");
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    try {
      None<Object> _none_2 = new None<Object>();
      final Function1<Object, Throwable> _function_3 = new Function1<Object, Throwable>() {
        public Throwable apply(final Object it) {
          return new Exception();
        }
      };
      OptExtensions.<Object>orThrow(_none_2, _function_3);
    } catch (final Throwable _t_1) {
      if (_t_1 instanceof Exception) {
        final Exception c_1 = (Exception)_t_1;
        OptExtensions.<String>assertSome(
          OptExtensions.<String>some("hello"), "hello");
      } else {
        throw Exceptions.sneakyThrow(_t_1);
      }
    }
  }
  
  @Test
  public void testIn() {
    boolean _in = IterableExtensions.<Integer>in(Integer.valueOf(2), Collections.<Integer>unmodifiableList(CollectionLiterals.<Integer>newArrayList(Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3))));
    Assert.assertTrue(_in);
    boolean _in_1 = IterableExtensions.<Integer>in(Integer.valueOf(2), Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3));
    Assert.assertTrue(_in_1);
    boolean _in_2 = IterableExtensions.<Integer>in(Integer.valueOf(6), Collections.<Integer>unmodifiableList(CollectionLiterals.<Integer>newArrayList(Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3))));
    Assert.assertFalse(_in_2);
    boolean _in_3 = IterableExtensions.<Integer>in(Integer.valueOf(6), Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3));
    Assert.assertFalse(_in_3);
    boolean _in_4 = IterableExtensions.<Integer>in(null, Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3));
    Assert.assertFalse(_in_4);
    boolean _in_5 = IterableExtensions.<Boolean>in(Boolean.valueOf(false), Boolean.valueOf(false));
    Assert.assertTrue(_in_5);
    final User u1 = new User("a", 12);
    final User u2 = new User("a", 12);
    final User u3 = new User("b", 13);
    boolean _in_6 = IterableExtensions.<User>in(u2, ((Iterable<User>) Collections.<User>unmodifiableList(CollectionLiterals.<User>newArrayList(u1, u3))));
    Assert.assertTrue(_in_6);
  }
  
  @Test
  public void testFilters() {
    Some<Integer> _some = OptExtensions.<Integer>some(Integer.valueOf(1));
    None<Integer> _none = OptExtensions.<Integer>none();
    Some<Integer> _some_1 = OptExtensions.<Integer>some(Integer.valueOf(2));
    None<Integer> _none_1 = OptExtensions.<Integer>none();
    None<Integer> _none_2 = OptExtensions.<Integer>none();
    Iterable<Integer> _filterEmpty = IterableExtensions.<Integer>filterEmpty(Collections.<Opt<Integer>>unmodifiableSet(CollectionLiterals.<Opt<Integer>>newHashSet(_some, _none, _some_1, _none_1, _none_2)));
    int _length = ((Object[])Conversions.unwrapArray(_filterEmpty, Object.class)).length;
    Assert.assertEquals(_length, 2);
    List<Integer> _distinct = IterableExtensions.<Integer>distinct(Collections.<Integer>unmodifiableSet(CollectionLiterals.<Integer>newHashSet(Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3), Integer.valueOf(1))));
    int _length_1 = ((Object[])Conversions.unwrapArray(_distinct, Object.class)).length;
    Assert.assertEquals(_length_1, 3);
  }
  
  @Test
  public void testConversions() {
    List<Integer> _list = IterableExtensions.<Integer>toList(Collections.<Integer>unmodifiableSet(CollectionLiterals.<Integer>newHashSet(Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3))));
    int _length = ((Object[])Conversions.unwrapArray(_list, Object.class)).length;
    Assert.assertEquals(_length, 3);
    Set<Integer> _set = org.eclipse.xtext.xbase.lib.IterableExtensions.<Integer>toSet(Collections.<Integer>unmodifiableList(CollectionLiterals.<Integer>newArrayList(Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3))));
    int _length_1 = ((Object[])Conversions.unwrapArray(_set, Object.class)).length;
    Assert.assertEquals(_length_1, 3);
    Pair<String, Integer> _mappedTo = Pair.<String, Integer>of("john", Integer.valueOf(23));
    Pair<String, Integer> _mappedTo_1 = Pair.<String, Integer>of("mary", Integer.valueOf(45));
    List<Pair<String, Integer>> _pairs = IterableExtensions.<String, Integer>toPairs(Collections.<String, Integer>unmodifiableMap(CollectionLiterals.<String, Integer>newHashMap(_mappedTo, _mappedTo_1)));
    Pair<String, Integer> _get = _pairs.get(1);
    final Procedure1<Pair<String, Integer>> _function = new Procedure1<Pair<String, Integer>>() {
      public void apply(final Pair<String, Integer> it) {
        String _key = it.getKey();
        Assert.assertEquals(_key, "mary");
        Integer _value = it.getValue();
        Assert.assertEquals((_value).intValue(), 45);
      }
    };
    ObjectExtensions.<Pair<String, Integer>>operator_doubleArrow(_get, _function);
    Pair<String, Integer> _mappedTo_2 = Pair.<String, Integer>of("john", Integer.valueOf(23));
    Pair<String, Integer> _mappedTo_3 = Pair.<String, Integer>of("mary", Integer.valueOf(45));
    Map<String, Integer> _map = IterableExtensions.<String, Integer>toMap(Collections.<Pair<String, Integer>>unmodifiableList(CollectionLiterals.<Pair<String, Integer>>newArrayList(_mappedTo_2, _mappedTo_3)));
    Integer _get_1 = _map.get("mary");
    Assert.assertEquals((_get_1).intValue(), 45);
  }
  
  @Test
  public void iteratorFunctions() {
    User _user = new User("john", 23);
    User _user_1 = new User("mary", 45);
    User _user_2 = new User("jim", 23);
    final List<User> users = Collections.<User>unmodifiableList(CollectionLiterals.<User>newArrayList(_user, _user_1, _user_2));
    final Function1<User, Integer> _function = new Function1<User, Integer>() {
      public Integer apply(final User it) {
        return Integer.valueOf(it.getAge());
      }
    };
    Map<Integer, List<User>> _groupBy = IterableExtensions.<Integer, User>groupBy(users, _function);
    List<User> _get = _groupBy.get(Integer.valueOf(23));
    int _length = ((Object[])Conversions.unwrapArray(_get, Object.class)).length;
    Assert.assertEquals(_length, 2);
    final Function1<User, Integer> _function_1 = new Function1<User, Integer>() {
      public Integer apply(final User it) {
        return Integer.valueOf(it.getAge());
      }
    };
    Map<User, Integer> _countBy = IterableExtensions.<Integer, User>countBy(users, _function_1);
    final Function1<User, Boolean> _function_2 = new Function1<User, Boolean>() {
      public Boolean apply(final User it) {
        int _age = it.getAge();
        return Boolean.valueOf((_age == 23));
      }
    };
    User _findFirst = org.eclipse.xtext.xbase.lib.IterableExtensions.<User>findFirst(users, _function_2);
    Integer _get_1 = _countBy.get(_findFirst);
    Assert.assertEquals((_get_1).intValue(), 2);
    Map<Integer, Integer> _count = IterableExtensions.<Integer>count(Collections.<Integer>unmodifiableList(CollectionLiterals.<Integer>newArrayList(Integer.valueOf(1), Integer.valueOf(3), Integer.valueOf(3), Integer.valueOf(3), Integer.valueOf(3), Integer.valueOf(4))));
    Integer _get_2 = _count.get(Integer.valueOf(3));
    Assert.assertEquals((_get_2).intValue(), 4);
    final Function1<User, Integer> _function_3 = new Function1<User, Integer>() {
      public Integer apply(final User it) {
        return Integer.valueOf(it.getAge());
      }
    };
    Map<Integer, User> _index = IterableExtensions.<Integer, User>index(users, _function_3);
    User _get_3 = _index.get(Integer.valueOf(45));
    String _name = _get_3.getName();
    Assert.assertEquals(_name, "mary");
    final Function1<User, Integer> _function_4 = new Function1<User, Integer>() {
      public Integer apply(final User it) {
        int _age = it.getAge();
        int _minus = (_age - 45);
        return Integer.valueOf((1 / _minus));
      }
    };
    Iterable<Opt<Integer>> _attemptMap = IterableExtensions.<User, Integer>attemptMap(users, _function_4);
    Iterable<Integer> _filterEmpty = IterableExtensions.<Integer>filterEmpty(_attemptMap);
    int _length_1 = ((Object[])Conversions.unwrapArray(_filterEmpty, Object.class)).length;
    Assert.assertEquals(_length_1, 2);
  }
  
  @Test
  public void testUsing() {
    final Readable closeable = new Readable();
    closeable.open();
    final Function1<Readable, String> _function = new Function1<Readable, String>() {
      public String apply(final Readable it) {
        return it.hello();
      }
    };
    Opt<String> _attemptUsing = CloseableExtensions.<Readable, String>attemptUsing(closeable, _function);
    OptExtensions.<String>assertSome(_attemptUsing, "hello, I am open!");
    Assert.assertTrue(closeable.isClosed);
    closeable.open();
    final Function1<Readable, Object> _function_1 = new Function1<Readable, Object>() {
      public Object apply(final Readable it) {
        try {
          Assert.assertFalse(closeable.isClosed);
          throw new Exception();
        } catch (Throwable _e) {
          throw Exceptions.sneakyThrow(_e);
        }
      }
    };
    CloseableExtensions.<Readable, Object>attemptUsing(closeable, _function_1);
    Assert.assertTrue(closeable.isClosed);
  }
  
  @Test
  public void testSum() {
    double _sum = IterableExtensions.<Integer>sum(Collections.<Integer>unmodifiableList(CollectionLiterals.<Integer>newArrayList(Integer.valueOf(1), Integer.valueOf(3), Integer.valueOf(2), Integer.valueOf(5), Integer.valueOf(7))));
    Assert.assertEquals(_sum, 18, 0);
  }
  
  @Test
  public void testAvg() {
    double _average = IterableExtensions.<Integer>average(Collections.<Integer>unmodifiableList(CollectionLiterals.<Integer>newArrayList(Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3), Integer.valueOf(4))));
    Assert.assertEquals(_average, 2.5, 0);
  }
  
  @Test
  public void testLogging() {
    Exception _exception = new Exception("ooo!");
    this.logger.error("hello error!", _exception);
  }
  
  @Test
  public void testMapTo() {
    final List<Object> list = CollectionLiterals.<Object>newLinkedList();
    list.add(Integer.valueOf(4));
    list.add(Integer.valueOf(9));
    final Iterable<Integer> mappedList = IterableExtensions.<Integer>mapAs(list, Integer.class);
    Integer _get = ((Integer[])Conversions.unwrapArray(mappedList, Integer.class))[0];
    Integer _integer = new Integer(4);
    Assert.assertEquals(_get, _integer);
    Integer _get_1 = ((Integer[])Conversions.unwrapArray(mappedList, Integer.class))[1];
    Integer _integer_1 = new Integer(9);
    Assert.assertEquals(_get_1, _integer_1);
  }
  
  @Test
  public void testFlatten() {
    Opt<Integer> _option = OptExtensions.<Integer>option(Integer.valueOf(5));
    final Opt<Opt<Integer>> x = OptExtensions.<Opt<Integer>>option(_option);
    Opt<Integer> _flatten = OptExtensions.<Integer>flatten(x);
    boolean _hasSome = _flatten.hasSome();
    Assert.assertTrue(_hasSome);
    Exception _exception = new Exception("test");
    Err<String> _err = OptExtensions.<String>err(_exception);
    final Opt<Opt<String>> e = OptExtensions.<Opt<String>>option(_err);
    Opt<String> _flatten_1 = OptExtensions.<String>flatten(e);
    boolean _hasError = _flatten_1.hasError();
    Assert.assertTrue(_hasError);
  }
}
