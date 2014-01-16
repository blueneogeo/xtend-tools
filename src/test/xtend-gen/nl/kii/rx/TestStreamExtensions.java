package nl.kii.rx;

import com.google.common.collect.Lists;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import nl.kii.rx.Collector;
import nl.kii.rx.StreamCommand;
import nl.kii.rx.StreamExtensions;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.IntegerRange;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.junit.Test;
import rx.Observable;
import rx.subjects.PublishSubject;
import rx.subjects.Subject;
import rx.util.functions.Func1;

@SuppressWarnings("all")
public class TestStreamExtensions {
  @Test
  public void testRXStream() {
    final PublishSubject<Integer> stream = StreamExtensions.<Integer>stream(Integer.class);
    Observable<Integer> _take = stream.take(6);
    final Func1<Integer,String> _function = new Func1<Integer,String>() {
      public String call(final Integer it) {
        return ("got number " + it);
      }
    };
    Observable<String> _map = _take.<String>map(_function);
    final Procedure1<String> _function_1 = new Procedure1<String>() {
      public void apply(final String it) {
        InputOutput.<String>println(it);
      }
    };
    Subject<String,String> _each = StreamExtensions.<String>each(_map, _function_1);
    final Procedure1<String> _function_2 = new Procedure1<String>() {
      public void apply(final String it) {
        InputOutput.<String>println(("printing again: " + it));
      }
    };
    Subject<String,String> _each_1 = StreamExtensions.<String>each(_each, _function_2);
    final Procedure1<Throwable> _function_3 = new Procedure1<Throwable>() {
      public void apply(final Throwable it) {
        InputOutput.<String>println(("caught: " + it));
      }
    };
    Subject<String,String> _onError = StreamExtensions.<String>onError(_each_1, _function_3);
    final Procedure1<Object> _function_4 = new Procedure1<Object>() {
      public void apply(final Object it) {
        InputOutput.<String>println("we are done!");
      }
    };
    StreamExtensions.<String>onFinish(_onError, _function_4);
    Subject<Integer,Integer> _doubleLessThan = StreamExtensions.<Integer>operator_doubleLessThan(stream, Integer.valueOf(2));
    Subject<Integer,Integer> _doubleLessThan_1 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan, Integer.valueOf(5));
    Subject<Integer,Integer> _doubleLessThan_2 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_1, Integer.valueOf(3));
    Exception _exception = new Exception("intentional error");
    Subject<Integer,Integer> _doubleLessThan_3 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_2, _exception);
    StreamCommand _done = StreamExtensions.done();
    StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_3, _done);
  }
  
  @Test
  public void testConnectedStream() {
    StreamExtensions.<Integer>streamTo(Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(1, 2, 3)), this.handler);
  }
  
  private final PublishSubject<Integer> handler = ObjectExtensions.<PublishSubject<Integer>>operator_doubleArrow(StreamExtensions.<Integer>stream(Integer.class), new Procedure1<PublishSubject<Integer>>() {
    public void apply(final PublishSubject<Integer> it) {
      final Procedure1<Integer> _function = new Procedure1<Integer>() {
        public void apply(final Integer it) {
          InputOutput.<String>println(("handler got number: " + it));
        }
      };
      StreamExtensions.<Integer>each(it, _function);
    }
  });
  
  @Test
  public void testCollector() {
    final PublishSubject<Integer> s = StreamExtensions.<Integer>stream(Integer.class);
    final Collector<Integer> bucket = StreamExtensions.<Integer>collect(s);
    Subject<Integer,Integer> _doubleLessThan = StreamExtensions.<Integer>operator_doubleLessThan(s, Integer.valueOf(3));
    StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan, Integer.valueOf(4));
    Collection<Integer> _get = bucket.get();
    int _length = ((Object[])Conversions.unwrapArray(_get, Object.class)).length;
    Assert.assertEquals(_length, 2);
    Subject<Integer,Integer> _doubleLessThan_1 = StreamExtensions.<Integer>operator_doubleLessThan(s, Integer.valueOf(2));
    StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_1, Integer.valueOf(9));
    Collection<Integer> _get_1 = bucket.get();
    int _length_1 = ((Object[])Conversions.unwrapArray(_get_1, Object.class)).length;
    Assert.assertEquals(_length_1, 4);
    bucket.clear();
    Collection<Integer> _get_2 = bucket.get();
    int _length_2 = ((Object[])Conversions.unwrapArray(_get_2, Object.class)).length;
    Assert.assertEquals(_length_2, 0);
  }
  
  @Test
  public void testUntil() {
    final PublishSubject<Integer> stream = StreamExtensions.<Integer>stream(Integer.class);
    final Function1<Integer,Boolean> _function = new Function1<Integer,Boolean>() {
      public Boolean apply(final Integer it) {
        return Boolean.valueOf(((it).intValue() > 10));
      }
    };
    Subject<Integer,Integer> _until = StreamExtensions.<Integer>until(stream, _function);
    final Func1<Integer,String> _function_1 = new Func1<Integer,String>() {
      public String call(final Integer it) {
        return it.toString();
      }
    };
    Observable<String> _map = _until.<String>map(_function_1);
    Observable<List<String>> _list = _map.toList();
    final Procedure1<List<String>> _function_2 = new Procedure1<List<String>>() {
      public void apply(final List<String> it) {
        String _join = IterableExtensions.join(it, ", ");
        InputOutput.<String>println(_join);
      }
    };
    StreamExtensions.<List<String>>operator_doubleGreaterThan(_list, _function_2);
    Subject<Integer,Integer> _doubleLessThan = StreamExtensions.<Integer>operator_doubleLessThan(stream, Integer.valueOf(4));
    Subject<Integer,Integer> _doubleLessThan_1 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan, Integer.valueOf(8));
    Subject<Integer,Integer> _doubleLessThan_2 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_1, Integer.valueOf(10));
    Subject<Integer,Integer> _doubleLessThan_3 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_2, Integer.valueOf(11));
    Subject<Integer,Integer> _doubleLessThan_4 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_3, Integer.valueOf(5));
    StreamCommand _done = StreamExtensions.done();
    StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_4, _done);
  }
  
  @Test
  public void testWhile() {
    final PublishSubject<Integer> stream = StreamExtensions.<Integer>stream(Integer.class);
    final Function1<Integer,Boolean> _function = new Function1<Integer,Boolean>() {
      public Boolean apply(final Integer it) {
        return Boolean.valueOf(((it).intValue() <= 10));
      }
    };
    Subject<Integer,Integer> _while_ = StreamExtensions.<Integer>while_(stream, _function);
    final Func1<Integer,String> _function_1 = new Func1<Integer,String>() {
      public String call(final Integer it) {
        return it.toString();
      }
    };
    Observable<String> _map = _while_.<String>map(_function_1);
    Observable<List<String>> _list = _map.toList();
    final Procedure1<List<String>> _function_2 = new Procedure1<List<String>>() {
      public void apply(final List<String> it) {
        String _join = IterableExtensions.join(it, ", ");
        InputOutput.<String>println(_join);
      }
    };
    StreamExtensions.<List<String>>operator_doubleGreaterThan(_list, _function_2);
    Subject<Integer,Integer> _doubleLessThan = StreamExtensions.<Integer>operator_doubleLessThan(stream, Integer.valueOf(4));
    Subject<Integer,Integer> _doubleLessThan_1 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan, Integer.valueOf(8));
    Subject<Integer,Integer> _doubleLessThan_2 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_1, Integer.valueOf(10));
    Subject<Integer,Integer> _doubleLessThan_3 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_2, Integer.valueOf(11));
    Subject<Integer,Integer> _doubleLessThan_4 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_3, Integer.valueOf(5));
    StreamCommand _done = StreamExtensions.done();
    StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_4, _done);
  }
  
  public void testLOTSOfItemsForMemoryLeaks() {
    final PublishSubject<Integer> stream = StreamExtensions.<Integer>stream(Integer.class);
    final Procedure1<Integer> _function = new Procedure1<Integer>() {
      public void apply(final Integer it) {
        if ((((it).intValue() % 1000000) == 0)) {
          InputOutput.<Integer>println(it);
        }
      }
    };
    StreamExtensions.<Integer>operator_doubleGreaterThan(stream, _function);
    IntegerRange _upTo = new IntegerRange(1, 100000000);
    for (final Integer i : _upTo) {
      StreamExtensions.<Integer>operator_doubleLessThan(stream, i);
    }
  }
}
