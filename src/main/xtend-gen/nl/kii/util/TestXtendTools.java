package nl.kii.util;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import nl.kii.util.None;
import nl.kii.util.Opt;
import nl.kii.util.Readable;
import nl.kii.util.Some;
import nl.kii.util.User;
import nl.kii.util.XtendTools;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Pair;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.junit.Test;

@SuppressWarnings("all")
public class TestXtendTools {
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
          None<Object> _none = XtendTools.<Object>none();
          return _none;
        }
      };
    Opt<None<Object>> _attempt = XtendTools.<None<Object>>attempt(_function);
    XtendTools.<None<Object>>assertNone(_attempt);
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
    Opt<Object> _attempt_1 = XtendTools.<Object>attempt(_function_1);
    XtendTools.<Object>assertNone(_attempt_1);
    final Function1<Object,String> _function_2 = new Function1<Object,String>() {
        public String apply(final Object it) {
          return "hello";
        }
      };
    Opt<String> _attempt_2 = XtendTools.<String>attempt(_function_2);
    XtendTools.<String>assertSome(_attempt_2, "hello");
  }
  
  @Test
  public void testIfValue() {
    final Function1<Object,String> _function = new Function1<Object,String>() {
        public String apply(final Object it) {
          return "hello";
        }
      };
    Opt<String> _ifTrue = XtendTools.<String, Object>ifTrue(true, _function);
    XtendTools.<String>assertSome(_ifTrue, "hello");
    final Function1<Object,String> _function_1 = new Function1<Object,String>() {
        public String apply(final Object it) {
          return "hello";
        }
      };
    Opt<String> _ifTrue_1 = XtendTools.<String, Object>ifTrue(false, _function_1);
    XtendTools.<String>assertNone(_ifTrue_1);
    Some<String> _some = XtendTools.<String>some("test");
    final Function1<String,String> _function_2 = new Function1<String,String>() {
        public String apply(final String it) {
          return "hello";
        }
      };
    Opt<String> _ifSome = XtendTools.<String, String>ifSome(_some, _function_2);
    XtendTools.<String>assertSome(_ifSome, "hello");
    None<Object> _none = XtendTools.<Object>none();
    final Function1<Object,String> _function_3 = new Function1<Object,String>() {
        public String apply(final Object it) {
          return "hello";
        }
      };
    Opt<String> _ifSome_1 = XtendTools.<String, Object>ifSome(_none, _function_3);
    XtendTools.<String>assertNone(_ifSome_1);
    final Function1<String,String> _function_4 = new Function1<String,String>() {
        public String apply(final String it) {
          String _xblockexpression = null;
          {
            XtendTools.print();
            _xblockexpression = (null);
          }
          return _xblockexpression;
        }
      };
    String _ifTrue_2 = XtendTools.<String>ifTrue("this should print", true, _function_4);
    Assert.assertEquals(_ifTrue_2, "this should print");
  }
  
  @Test
  public void testOr() {
    Some<String> _some = XtendTools.<String>some("hi");
    String _or = XtendTools.<String>or(_some, "hello");
    Assert.assertEquals(_or, "hi");
    None<String> _none = XtendTools.<String>none();
    String _or_1 = XtendTools.<String>or(_none, "hello");
    Assert.assertEquals(_or_1, "hello");
    Some<String> _some_1 = XtendTools.<String>some("hi");
    final Function1<Object,String> _function = new Function1<Object,String>() {
        public String apply(final Object it) {
          String _plus = ("a" + "b");
          return _plus;
        }
      };
    String _or_2 = XtendTools.<String>or(_some_1, _function);
    Assert.assertEquals(_or_2, "hi");
    None<String> _none_1 = XtendTools.<String>none();
    final Function1<Object,String> _function_1 = new Function1<Object,String>() {
        public String apply(final Object it) {
          String _plus = ("a" + "b");
          return _plus;
        }
      };
    String _or_3 = XtendTools.<String>or(_none_1, _function_1);
    Assert.assertEquals(_or_3, "ab");
    try {
      Some<String> _some_2 = XtendTools.<String>some("hi");
      final Function1<Object,Exception> _function_2 = new Function1<Object,Exception>() {
          public Exception apply(final Object it) {
            Exception _exception = new Exception();
            return _exception;
          }
        };
      XtendTools.<String>orThrow(_some_2, _function_2);
    } catch (final Throwable _t) {
      if (_t instanceof Exception) {
        final Exception c = (Exception)_t;
        Some<String> _some_3 = XtendTools.<String>some("hello");
        XtendTools.<String>assertSome(_some_3, "hi");
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    try {
      None<Object> _none_2 = XtendTools.<Object>none();
      final Function1<Object,Exception> _function_3 = new Function1<Object,Exception>() {
          public Exception apply(final Object it) {
            Exception _exception = new Exception();
            return _exception;
          }
        };
      XtendTools.<Object>orThrow(_none_2, _function_3);
    } catch (final Throwable _t_1) {
      if (_t_1 instanceof Exception) {
        final Exception c_1 = (Exception)_t_1;
        Some<String> _some_4 = XtendTools.<String>some("hello");
        XtendTools.<String>assertSome(_some_4, "hello");
      } else {
        throw Exceptions.sneakyThrow(_t_1);
      }
    }
  }
  
  @Test
  public void testIn() {
    boolean _in = XtendTools.<Integer>in(Integer.valueOf(2), Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3))));
    Assert.assertTrue(_in);
    boolean _in_1 = XtendTools.<Integer>in(Integer.valueOf(2), Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3));
    Assert.assertTrue(_in_1);
    boolean _in_2 = XtendTools.<Integer>in(Integer.valueOf(6), Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3))));
    Assert.assertFalse(_in_2);
    boolean _in_3 = XtendTools.<Integer>in(Integer.valueOf(6), Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3));
    Assert.assertFalse(_in_3);
    boolean _in_4 = XtendTools.<Object>in(null, Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3));
    Assert.assertFalse(_in_4);
    boolean _in_5 = XtendTools.<Boolean>in(Boolean.valueOf(false), Boolean.valueOf(false));
    Assert.assertTrue(_in_5);
  }
  
  @Test
  public void testFilters() {
    Some<Integer> _some = XtendTools.<Integer>some(Integer.valueOf(1));
    None<Integer> _none = XtendTools.<Integer>none();
    Some<Integer> _some_1 = XtendTools.<Integer>some(Integer.valueOf(2));
    None<Integer> _none_1 = XtendTools.<Integer>none();
    None<Integer> _none_2 = XtendTools.<Integer>none();
    Iterable<Integer> _filterEmpty = XtendTools.<Integer>filterEmpty(Collections.<Opt<Integer>>unmodifiableSet(Sets.<Opt<Integer>>newHashSet(_some, _none, _some_1, _none_1, _none_2)));
    int _length = ((Object[])Conversions.unwrapArray(_filterEmpty, Object.class)).length;
    Assert.assertEquals(_length, 2);
    Iterable<Integer> _distinct = XtendTools.<Integer>distinct(Collections.<Integer>unmodifiableSet(Sets.<Integer>newHashSet(1, 2, 3, 1)));
    int _length_1 = ((Object[])Conversions.unwrapArray(_distinct, Object.class)).length;
    Assert.assertEquals(_length_1, 3);
  }
  
  @Test
  public void testConversions() {
    List<Integer> _list = XtendTools.<Integer>toList(Collections.<Integer>unmodifiableSet(Sets.<Integer>newHashSet(1, 2, 3)));
    int _length = ((Object[])Conversions.unwrapArray(_list, Object.class)).length;
    Assert.assertEquals(_length, 3);
    Set<Integer> _set = XtendTools.<Integer>toSet(Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(1, 2, 3)));
    int _length_1 = ((Object[])Conversions.unwrapArray(_set, Object.class)).length;
    Assert.assertEquals(_length_1, 3);
    Map<String,Integer> _xsetliteral = null;
    Map<String,Integer> _tempMap = Maps.<String, Integer>newHashMap();
    _tempMap.put("john", Integer.valueOf(23));
    _tempMap.put("mary", Integer.valueOf(45));
    _xsetliteral = Collections.<String, Integer>unmodifiableMap(_tempMap);
    Iterable<Pair<String,Integer>> _pairs = XtendTools.<String, Integer>toPairs(_xsetliteral);
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
    Map<String,Integer> _map = XtendTools.<String, Integer>toMap(Collections.<Pair<String,Integer>>unmodifiableList(Lists.<Pair<String,Integer>>newArrayList(_mappedTo, _mappedTo_1)));
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
    Map<Integer,List<User>> _groupBy = XtendTools.<Integer, User>groupBy(users, _function);
    List<User> _get = _groupBy.get(Integer.valueOf(23));
    int _length = ((Object[])Conversions.unwrapArray(_get, Object.class)).length;
    Assert.assertEquals(_length, 2);
    final Function1<User,Integer> _function_1 = new Function1<User,Integer>() {
        public Integer apply(final User it) {
          int _age = it.getAge();
          return Integer.valueOf(_age);
        }
      };
    Map<User,Integer> _countBy = XtendTools.<Integer, User>countBy(users, _function_1);
    final Function1<User,Boolean> _function_2 = new Function1<User,Boolean>() {
        public Boolean apply(final User it) {
          int _age = it.getAge();
          boolean _equals = (_age == 23);
          return Boolean.valueOf(_equals);
        }
      };
    User _findFirst = IterableExtensions.<User>findFirst(users, _function_2);
    Integer _get_1 = _countBy.get(_findFirst);
    Assert.assertEquals((_get_1).intValue(), 2);
    Map<Integer,Integer> _count = XtendTools.<Integer>count(Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(1, 3, 3, 3, 3, 4)));
    Integer _get_2 = _count.get(Integer.valueOf(3));
    Assert.assertEquals((_get_2).intValue(), 4);
    final Function1<User,Integer> _function_3 = new Function1<User,Integer>() {
        public Integer apply(final User it) {
          int _age = it.getAge();
          return Integer.valueOf(_age);
        }
      };
    Map<Integer,User> _index = XtendTools.<Integer, User>index(users, _function_3);
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
    Iterable<Opt<Integer>> _attemptMap = XtendTools.<User, Integer>attemptMap(users, _function_4);
    Iterable<Integer> _filterEmpty = XtendTools.<Integer>filterEmpty(_attemptMap);
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
    Opt<String> _attemptUsing = XtendTools.<Readable, String>attemptUsing(closeable, _function);
    XtendTools.<String>assertSome(_attemptUsing, "hello, I am open!");
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
    XtendTools.<Readable, Object>attemptUsing(closeable, _function_1);
    Assert.assertTrue(closeable.isClosed);
  }
  
  @Test
  public void testSum() {
    double _sum = XtendTools.<Integer>sum(Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(1, 3, 2, 5, 7)));
    Assert.assertEquals(_sum, 18, 0);
  }
  
  @Test
  public void testAvg() {
    double _average = XtendTools.<Integer>average(Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(1, 2, 3, 4)));
    Assert.assertEquals(_average, 2.5, 0);
  }
}
