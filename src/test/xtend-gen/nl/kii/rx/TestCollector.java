package nl.kii.rx;

import java.util.concurrent.ConcurrentHashMap;
import nl.kii.rx.Countdown;
import nl.kii.rx.Gatherer;
import nl.kii.rx.StreamExtensions;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.Pair;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Test;
import rx.Observable;
import rx.subjects.Subject;

@SuppressWarnings("all")
public class TestCollector {
  @Test
  public void testCountDown() {
    final Countdown countdown = new Countdown();
    final Procedure1<? super Boolean> c1 = countdown.await();
    final Procedure1<? super Boolean> c2 = countdown.await();
    final Procedure1<? super Boolean> c3 = countdown.await();
    Observable<Pair<String,Boolean>> _stream = countdown.stream();
    final Procedure1<Pair<String,Boolean>> _function = new Procedure1<Pair<String,Boolean>>() {
      public void apply(final Pair<String,Boolean> it) {
        InputOutput.<String>println("counting...");
      }
    };
    Subject<Pair<String,Boolean>,Pair<String,Boolean>> _each = StreamExtensions.<Pair<String,Boolean>>each(_stream, _function);
    final Procedure1<Object> _function_1 = new Procedure1<Object>() {
      public void apply(final Object it) {
        Boolean _isSuccess = countdown.isSuccess();
        String _plus = ("countdown done. success:" + _isSuccess);
        InputOutput.<String>println(_plus);
      }
    };
    StreamExtensions.<Pair<String,Boolean>>onFinish(_each, _function_1);
    c2.apply(Boolean.valueOf(true));
    c1.apply(Boolean.valueOf(true));
    c3.apply(Boolean.valueOf(true));
  }
  
  @Test
  public void testGatherer() {
    final Gatherer<String> collector = new Gatherer<String>();
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
    Subject<Pair<String,String>,Pair<String,String>> _each = StreamExtensions.<Pair<String,String>>each(_stream, _function);
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
    StreamExtensions.<Pair<String,String>>onFinish(_each, _function_1);
    cage.apply("12");
    cname.apply("John");
    cuser.apply("Christian");
  }
}
