package nl.kii.util;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import nl.kii.util.CloseableExtensions;
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
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Pair;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@SuppressWarnings("all")
public class TestXtendTools {
  @Extension
  private Log logger = new Function0<Log>() {
    public Log apply() {
      Class<? extends TestXtendTools> _class = TestXtendTools.this.getClass();
      Logger _logger = LoggerFactory.getLogger(_class);
      Log _wrapper = LogExtensions.wrapper(_logger);
      return _wrapper;
    }
  }.apply();
  
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
    final Function1<Object,None<Object>> _function = new Function1<Object,None<Object>>() {
        public None<Object> apply(final Object it) {
          None<Object> _none = OptExtensions.<Object>none();
          return _none;
        }
      };
    Opt<None<Object>> _attempt = OptExtensions.<None<Object>>attempt(_function);
    OptExtensions.<None<Object>>assertNone(_attempt);
    final Function1<Object,Object> _function_1 = new Function1<Object,Object>() {
        public Object apply(final Object it) {
          try {
            Exception _exception = new Exception();
            throw _exception;
          } catch (Throwable _e) {
            throw Exceptions.sneakyThrow(_e);
          }
        }
      };
    Opt<Object> _attempt_1 = OptExtensions.<Object>attempt(_function_1);
    OptExtensions.<Object>assertNone(_attempt_1);
    final Function1<Object,String> _function_2 = new Function1<Object,String>() {
        public String apply(final Object it) {
          return "hello";
        }
      };
    Opt<String> _attempt_2 = OptExtensions.<String>attempt(_function_2);
    OptExtensions.<String>assertSome(_attempt_2, "hello");
  }
  
  @Test
  public void testIfValue() {
    final Function1<Object,String> _function = new Function1<Object,String>() {
        public String apply(final Object it) {
          return "hello";
        }
      };
    Opt<String> _ifTrue = OptExtensions.<String, Object>ifTrue(true, _function);
    OptExtensions.<String>assertSome(_ifTrue, "hello");
    final Function1<Object,String> _function_1 = new Function1<Object,String>() {
        public String apply(final Object it) {
          return "hello";
        }
      };
    Opt<String> _ifTrue_1 = OptExtensions.<String, Object>ifTrue(false, _function_1);
    OptExtensions.<String>assertNone(_ifTrue_1);
    Some<String> _some = OptExtensions.<String>some("test");
    final Function1<String,String> _function_2 = new Function1<String,String>() {
        public String apply(final String it) {
          return "hello";
        }
      };
    Opt<String> _ifSome = OptExtensions.<String, String>ifSome(_some, _function_2);
    OptExtensions.<String>assertSome(_ifSome, "hello");
    None<Object> _none = OptExtensions.<Object>none();
    final Function1<Object,String> _function_3 = new Function1<Object,String>() {
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
    final Function1<Object,String> _function = new Function1<Object,String>() {
        public String apply(final Object it) {
          String _plus = ("a" + "b");
          return _plus;
        }
      };
    String _or_2 = OptExtensions.<String>or(_some_1, _function);
    Assert.assertEquals(_or_2, "hi");
    None<String> _none_1 = OptExtensions.<String>none();
    final Function1<Object,String> _function_1 = new Function1<Object,String>() {
        public String apply(final Object it) {
          String _plus = ("a" + "b");
          return _plus;
        }
      };
    String _or_3 = OptExtensions.<String>or(_none_1, _function_1);
    Assert.assertEquals(_or_3, "ab");
    try {
      Some<String> _some_2 = OptExtensions.<String>some("hi");
      final Function1<Object,Exception> _function_2 = new Function1<Object,Exception>() {
          public Exception apply(final Object it) {
            Exception _exception = new Exception();
            return _exception;
          }
        };
      OptExtensions.<String>orThrow(_some_2, _function_2);
    } catch (final Throwable _t) {
      if (_t instanceof Exception) {
        final Exception c = (Exception)_t;
        Some<String> _some_3 = OptExtensions.<String>some("hello");
        OptExtensions.<String>assertSome(_some_3, "hi");
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    try {
      final Function1<Object,Exception> _function_3 = new Function1<Object,Exception>() {
          public Exception apply(final Object it) {
            Exception _exception = new Exception();
            return _exception;
          }
        };
      OptExtensions.<Class<None>>orThrow(None.class, _function_3);
    } catch (final Throwable _t_1) {
      if (_t_1 instanceof Exception) {
        final Exception c_1 = (Exception)_t_1;
        Some<String> _some_4 = OptExtensions.<String>some("hello");
        OptExtensions.<String>assertSome(_some_4, "hello");
      } else {
        throw Exceptions.sneakyThrow(_t_1);
      }
    }
  }
  
  @Test
  public void testIn() {
    boolean _in = IterableExtensions.<Integer>in(Integer.valueOf(2), Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3))));
    Assert.assertTrue(_in);
    boolean _in_1 = IterableExtensions.<Integer>in(Integer.valueOf(2), Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3));
    Assert.assertTrue(_in_1);
    boolean _in_2 = IterableExtensions.<Integer>in(Integer.valueOf(6), Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3))));
    Assert.assertFalse(_in_2);
    boolean _in_3 = IterableExtensions.<Integer>in(Integer.valueOf(6), Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3));
    Assert.assertFalse(_in_3);
    boolean _in_4 = IterableExtensions.<Object>in(null, Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3));
    Assert.assertFalse(_in_4);
    boolean _in_5 = IterableExtensions.<Boolean>in(Boolean.valueOf(false), Boolean.valueOf(false));
    Assert.assertTrue(_in_5);
  }
  
  @Test
  public void testFilters() {
    Some<Integer> _some = OptExtensions.<Integer>some(Integer.valueOf(1));
    None<Integer> _none = OptExtensions.<Integer>none();
    Some<Integer> _some_1 = OptExtensions.<Integer>some(Integer.valueOf(2));
    None<Integer> _none_1 = OptExtensions.<Integer>none();
    None<Integer> _none_2 = OptExtensions.<Integer>none();
    Iterable<Integer> _filterEmpty = IterableExtensions.<Integer>filterEmpty(Collections.<Opt<Integer>>unmodifiableSet(Sets.<Opt<Integer>>newHashSet(_some, _none, _some_1, _none_1, _none_2)));
    int _length = ((Object[])Conversions.unwrapArray(_filterEmpty, Object.class)).length;
    Assert.assertEquals(_length, 2);
    Iterable<Integer> _distinct = IterableExtensions.<Integer>distinct(Collections.<Integer>unmodifiableSet(Sets.<Integer>newHashSet(1, 2, 3, 1)));
    int _length_1 = ((Object[])Conversions.unwrapArray(_distinct, Object.class)).length;
    Assert.assertEquals(_length_1, 3);
  }
  
  @Test
  public void testConversions() {
    List<Integer> _list = IterableExtensions.<Integer>toList(Collections.<Integer>unmodifiableSet(Sets.<Integer>newHashSet(1, 2, 3)));
    int _length = ((Object[])Conversions.unwrapArray(_list, Object.class)).length;
    Assert.assertEquals(_length, 3);
    Set<Integer> _set = IterableExtensions.<Integer>toSet(Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(1, 2, 3)));
    int _length_1 = ((Object[])Conversions.unwrapArray(_set, Object.class)).length;
    Assert.assertEquals(_length_1, 3);
    Map<String,Integer> _xsetliteral = null;
    Map<String,Integer> _tempMap = Maps.<String, Integer>newHashMap();
    _tempMap.put("john", Integer.valueOf(23));
    _tempMap.put("mary", Integer.valueOf(45));
    _xsetliteral = Collections.<String, Integer>unmodifiableMap(_tempMap);
    Iterable<Pair<String,Integer>> _pairs = IterableExtensions.<String, Integer>toPairs(_xsetliteral);
    Pair<String,Integer> _get = ((Pair<String,Integer>[])Conversions.unwrapArray(_pairs, Pair.class))[1];
    final Procedure1<Pair<String,Integer>> _function = new Procedure1<Pair<String,Integer>>() {
        public void apply(final Pair<String,Integer> it) {
          String _key = it.getKey();
          Assert.assertEquals(_key, "mary");
          Integer _value = it.getValue();
          Assert.assertEquals((_value).intValue(), 45);
        }
      };
    ObjectExtensions.<Pair<String,Integer>>operator_doubleArrow(_get, _function);
    Pair<String,Integer> _mappedTo = Pair.<String, Integer>of("john", Integer.valueOf(23));
    Pair<String,Integer> _mappedTo_1 = Pair.<String, Integer>of("mary", Integer.valueOf(45));
    Map<String,Integer> _map = IterableExtensions.<String, Integer>toMap(Collections.<Pair<String,Integer>>unmodifiableList(Lists.<Pair<String,Integer>>newArrayList(_mappedTo, _mappedTo_1)));
    Integer _get_1 = _map.get("mary");
    Assert.assertEquals((_get_1).intValue(), 45);
  }
  
  @Test
  public void iteratorFunctions() {
    User _user = new User("john", 23);
    User _user_1 = new User("mary", 45);
    User _user_2 = new User("jim", 23);
    final List<User> users = Collections.<User>unmodifiableList(Lists.<User>newArrayList(_user, _user_1, _user_2));
    final Function1<User,Integer> _function = new Function1<User,Integer>() {
        public Integer apply(final User it) {
          int _age = it.getAge();
          return Integer.valueOf(_age);
        }
      };
    Map<Integer,List<User>> _groupBy = IterableExtensions.<Integer, User>groupBy(users, _function);
    List<User> _get = _groupBy.get(Integer.valueOf(23));
    int _length = ((Object[])Conversions.unwrapArray(_get, Object.class)).length;
    Assert.assertEquals(_length, 2);
    final Function1<User,Integer> _function_1 = new Function1<User,Integer>() {
        public Integer apply(final User it) {
          int _age = it.getAge();
          return Integer.valueOf(_age);
        }
      };
    Map<User,Integer> _countBy = IterableExtensions.<Integer, User>countBy(users, _function_1);
    final Function1<User,Boolean> _function_2 = new Function1<User,Boolean>() {
        public Boolean apply(final User it) {
          int _age = it.getAge();
          boolean _equals = (_age == 23);
          return Boolean.valueOf(_equals);
        }
      };
    User _findFirst = org.eclipse.xtext.xbase.lib.IterableExtensions.<User>findFirst(users, _function_2);
    Integer _get_1 = _countBy.get(_findFirst);
    Assert.assertEquals((_get_1).intValue(), 2);
    Map<Integer,Integer> _count = IterableExtensions.<Integer>count(Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(1, 3, 3, 3, 3, 4)));
    Integer _get_2 = _count.get(Integer.valueOf(3));
    Assert.assertEquals((_get_2).intValue(), 4);
    final Function1<User,Integer> _function_3 = new Function1<User,Integer>() {
        public Integer apply(final User it) {
          int _age = it.getAge();
          return Integer.valueOf(_age);
        }
      };
    Map<Integer,User> _index = IterableExtensions.<Integer, User>index(users, _function_3);
    User _get_3 = _index.get(Integer.valueOf(45));
    String _name = _get_3.getName();
    Assert.assertEquals(_name, "mary");
    final Function1<User,Integer> _function_4 = new Function1<User,Integer>() {
        public Integer apply(final User it) {
          int _age = it.getAge();
          int _minus = (_age - 45);
          int _divide = (1 / _minus);
          return Integer.valueOf(_divide);
        }
      };
    Iterable<Opt<Integer>> _attemptMap = IterableExtensions.<User, Integer>attemptMap(users, _function_4);
    Iterable<Integer> _filterEmpty = IterableExtensions.<Integer>filterEmpty(_attemptMap);
    int _length_1 = ((Object[])Conversions.unwrapArray(_filterEmpty, Object.class)).length;
    Assert.assertEquals(_length_1, 2);
  }
  
  @Test
  public void testUsing() {
    Readable _readable = new Readable();
    final Readable closeable = _readable;
    closeable.open();
    final Function1<Readable,String> _function = new Function1<Readable,String>() {
        public String apply(final Readable it) {
          String _hello = it.hello();
          return _hello;
        }
      };
    Opt<String> _attemptUsing = CloseableExtensions.<Readable, String>attemptUsing(closeable, _function);
    OptExtensions.<String>assertSome(_attemptUsing, "hello, I am open!");
    Assert.assertTrue(closeable.isClosed);
    closeable.open();
    final Function1<Readable,Object> _function_1 = new Function1<Readable,Object>() {
        public Object apply(final Readable it) {
          try {
            Assert.assertFalse(closeable.isClosed);
            Exception _exception = new Exception();
            throw _exception;
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
    double _sum = IterableExtensions.<Integer>sum(Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(1, 3, 2, 5, 7)));
    Assert.assertEquals(_sum, 18, 0);
  }
  
  @Test
  public void testAvg() {
    double _average = IterableExtensions.<Integer>average(Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(1, 2, 3, 4)));
    Assert.assertEquals(_average, 2.5, 0);
  }
  
  @Test
  public void testLogging() {
    final List<Integer> list = Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(1, 2, 3));
    LogExtensions.<Integer>printEach(list);
    LogExtensions.<Integer>printEach(list, "got list:");
    LogExtensions.<Integer>info(list, this.logger);
  }
  
  @Test
  public void testMapTo() {
    final List<Object> list = CollectionLiterals.<Object>newLinkedList();
    list.add(Integer.valueOf(4));
    list.add(Integer.valueOf(9));
    final Iterable<Integer> mappedList = IterableExtensions.<Integer>mapTo(list, Integer.class);
    Integer _get = ((Integer[])Conversions.unwrapArray(mappedList, Integer.class))[0];
    Integer _integer = new Integer(4);
    Assert.assertEquals(_get, _integer);
    Integer _get_1 = ((Integer[])Conversions.unwrapArray(mappedList, Integer.class))[1];
    Integer _integer_1 = new Integer(9);
    Assert.assertEquals(_get_1, _integer_1);
  }
}
