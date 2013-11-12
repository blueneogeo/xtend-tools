package nl.kii.rx;

import com.google.common.collect.Lists;
import java.util.Collection;
import java.util.Collections;
import nl.kii.rx.Collector;
import nl.kii.rx.StreamExtensions;
import nl.kii.rx.Subscriber;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.InputOutput;
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
          String _plus = ("got number " + it);
          return _plus;
        }
      };
    Observable<String> _map = _take.<String>map(_function);
    final Procedure1<String> _function_1 = new Procedure1<String>() {
        public void apply(final String it) {
          String _plus = ("a: " + it);
          InputOutput.<String>println(_plus);
        }
      };
    Subscriber<String> _each = StreamExtensions.<String>each(_map, _function_1);
    final Procedure1<Object> _function_2 = new Procedure1<Object>() {
        public void apply(final Object it) {
          InputOutput.<String>println("we are done!");
        }
      };
    Subscriber<String> _onFinish = _each.onFinish(_function_2);
    final Procedure1<Throwable> _function_3 = new Procedure1<Throwable>() {
        public void apply(final Throwable it) {
          String _plus = ("caught: " + it);
          InputOutput.<String>println(_plus);
        }
      };
    Subscriber<String> _onError = _onFinish.onError(_function_3);
    _onError.start();
    final Procedure1<PublishSubject<Integer>> _function_4 = new Procedure1<PublishSubject<Integer>>() {
        public void apply(final PublishSubject<Integer> it) {
          StreamExtensions.<Integer>apply(it, Integer.valueOf(2));
          StreamExtensions.<Integer>apply(it, Integer.valueOf(5));
          StreamExtensions.<Integer>apply(it, Integer.valueOf(3));
          Exception _exception = new Exception("this error is intentional");
          StreamExtensions.<Integer>error(it, _exception);
          StreamExtensions.<Integer>finish(it);
        }
      };
    ObjectExtensions.<PublishSubject<Integer>>operator_doubleArrow(stream, _function_4);
  }
  
  @Test
  public void testConnectedStream() {
    StreamExtensions.<Integer>streamTo(Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(1, 2, 3)), this.handler);
  }
  
  private final PublishSubject<Integer> handler = new Function0<PublishSubject<Integer>>() {
    public PublishSubject<Integer> apply() {
      PublishSubject<Integer> _stream = StreamExtensions.<Integer>stream(Integer.class);
      final Procedure1<PublishSubject<Integer>> _function = new Procedure1<PublishSubject<Integer>>() {
          public void apply(final PublishSubject<Integer> it) {
            final Procedure1<Integer> _function = new Procedure1<Integer>() {
                public void apply(final Integer it) {
                  String _plus = ("handler got number: " + it);
                  InputOutput.<String>println(_plus);
                }
              };
            Subscriber<Integer> _each = StreamExtensions.<Integer>each(it, _function);
            _each.start();
          }
        };
      PublishSubject<Integer> _doubleArrow = ObjectExtensions.<PublishSubject<Integer>>operator_doubleArrow(_stream, _function);
      return _doubleArrow;
    }
  }.apply();
  
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
}
