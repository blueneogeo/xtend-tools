package nl.kii.rx;

import java.util.concurrent.ConcurrentHashMap;
import nl.kii.rx.Countdown;
import nl.kii.rx.Gatherer;
import nl.kii.rx.StreamExtensions;
import nl.kii.rx.Subscriber;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.Pair;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Test;
import rx.Observable;

@SuppressWarnings("all")
public class TestCollector {
  @Test
  public void testCountDown() {
    Countdown _countdown = new Countdown();
    final Countdown countdown = _countdown;
    final Procedure1<? super Boolean> c1 = countdown.await();
    final Procedure1<? super Boolean> c2 = countdown.await();
    final Procedure1<? super Boolean> c3 = countdown.await();
    Observable<Pair<String,Boolean>> _stream = countdown.stream();
    final Procedure1<Pair<String,Boolean>> _function = new Procedure1<Pair<String,Boolean>>() {
        public void apply(final Pair<String,Boolean> it) {
          InputOutput.<String>println("counting...");
        }
      };
    Subscriber<Pair<String,Boolean>> _each = StreamExtensions.<Pair<String,Boolean>>each(_stream, _function);
    final Procedure1<Object> _function_1 = new Procedure1<Object>() {
        public void apply(final Object it) {
          Boolean _isSuccess = countdown.isSuccess();
          String _plus = ("countdown done. success:" + _isSuccess);
          InputOutput.<String>println(_plus);
        }
      };
    _each.onFinish(_function_1);
    c2.apply(Boolean.valueOf(true));
    c1.apply(Boolean.valueOf(true));
    c3.apply(Boolean.valueOf(true));
  }
  
  @Test
  public void testGatherer() {
    Gatherer<String> _gatherer = new Gatherer<String>();
    final Gatherer<String> collector = _gatherer;
    final Procedure1<? super String> cuser = collector.await("user");
    final Procedure1<? super String> cname = collector.await("name");
    final Procedure1<? super String> cage = collector.await("age");
    Observable<Pair<String,String>> _stream = collector.stream();
    final Procedure1<Pair<String,String>> _function = new Procedure1<Pair<String,String>>() {
        public void apply(final Pair<String,String> it) {
          String _key = it.getKey();
          String _plus = ("got " + _key);
          String _plus_1 = (_plus + " has value ");
          String _value = it.getValue();
          String _plus_2 = (_plus_1 + _value);
          InputOutput.<String>println(_plus_2);
        }
      };
    Subscriber<Pair<String,String>> _each = StreamExtensions.<Pair<String,String>>each(_stream, _function);
    final Procedure1<Object> _function_1 = new Procedure1<Object>() {
        public void apply(final Object it) {
          final ConcurrentHashMap<String,String> it_1 = collector.result();
          String _get = it_1.get("user");
          String _plus = ("found user " + _get);
          InputOutput.<String>println(_plus);
          String _get_1 = it_1.get("name");
          String _plus_1 = ("found name " + _get_1);
          InputOutput.<String>println(_plus_1);
          String _get_2 = it_1.get("age");
          String _plus_2 = ("found age " + _get_2);
          InputOutput.<String>println(_plus_2);
        }
      };
    _each.onFinish(_function_1);
    cage.apply("12");
    cname.apply("John");
    cuser.apply("Christian");
  }
}