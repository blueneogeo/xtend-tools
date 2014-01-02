package nl.kii.rx;

import com.google.common.base.Objects;
import java.io.Serializable;
import nl.kii.rx.PromiseExtensions;
import nl.kii.rx.StreamExtensions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.junit.Test;
import rx.Observable;
import rx.subjects.ReplaySubject;
import rx.subjects.Subject;
import rx.util.functions.Func1;

@SuppressWarnings("all")
public class TestPromiseStreamExtensions {
  @Test
  public void testRXPromise() {
    final ReplaySubject<String> promise = PromiseExtensions.<String>promise(String.class);
    final Func1<String,String> _function = new Func1<String,String>() {
      public String call(final String it) {
        String _lowerCase = it.toLowerCase();
        return _lowerCase;
      }
    };
    Observable<String> _map = promise.<String>map(_function);
    final Func1<String,String> _function_1 = new Func1<String,String>() {
      public String call(final String it) {
        return ("Hey cool I got this text: " + it);
      }
    };
    Observable<String> _map_1 = _map.<String>map(_function_1);
    final Procedure1<String> _function_2 = new Procedure1<String>() {
      public void apply(final String it) {
        InputOutput.<String>println(it);
      }
    };
    Subject<String,String> _each = StreamExtensions.<String>each(_map_1, _function_2);
    final Procedure1<Object> _function_3 = new Procedure1<Object>() {
      public void apply(final Object it) {
        InputOutput.<String>println("we are done!");
      }
    };
    Subject<String,String> _onFinish = StreamExtensions.<String>onFinish(_each, _function_3);
    final Procedure1<Throwable> _function_4 = new Procedure1<Throwable>() {
      public void apply(final Throwable it) {
        InputOutput.<String>println(("caught: " + it));
      }
    };
    StreamExtensions.<String>onError(_onFinish, _function_4);
    PromiseExtensions.<String>apply(promise, "Hello!");
  }
  
  @Test
  public void testRXPromiseOperators() {
    final ReplaySubject<String> promise = PromiseExtensions.<String>promise(String.class);
    final Function1<String,String> _function = new Function1<String,String>() {
      public String apply(final String it) {
        String _lowerCase = it.toLowerCase();
        return _lowerCase;
      }
    };
    Observable<String> _mappedTo = StreamExtensions.<String, String>operator_mappedTo(promise, _function);
    final Function1<String,String> _function_1 = new Function1<String,String>() {
      public String apply(final String it) {
        return ("Hey cool I got this text: " + it);
      }
    };
    Observable<String> _mappedTo_1 = StreamExtensions.<String, String>operator_mappedTo(_mappedTo, _function_1);
    final Procedure1<String> _function_2 = new Procedure1<String>() {
      public void apply(final String it) {
        InputOutput.<String>println(it);
      }
    };
    StreamExtensions.<String>operator_doubleGreaterThan(_mappedTo_1, _function_2);
    PromiseExtensions.<String>apply(promise, "Hello!");
  }
  
  @Test
  public void testAsyncThen() {
    ReplaySubject<String> _promise = PromiseExtensions.<String>promise(String.class);
    ReplaySubject<String> _apply = PromiseExtensions.<String>apply(_promise, "Christian");
    final Function1<String,Observable<String>> _function = new Function1<String,Observable<String>>() {
      public Observable<String> apply(final String it) {
        Observable<String> _greeting$ = TestPromiseStreamExtensions.this.toGreeting$(it);
        return _greeting$;
      }
    };
    Observable<String> _next = StreamExtensions.<String, String>next(_apply, _function);
    final Procedure1<String> _function_1 = new Procedure1<String>() {
      public void apply(final String it) {
        Assert.assertEquals(it, "Welcome Christian");
        InputOutput.<String>println("done!");
      }
    };
    PromiseExtensions.<String>then(_next, _function_1);
  }
  
  @Test
  public void testCatchErrors() {
    final ReplaySubject<String> promise = PromiseExtensions.<String>promise(String.class);
    final Func1<String,Serializable> _function = new Func1<String,Serializable>() {
      public Serializable call(final String it) {
        Serializable _xifexpression = null;
        boolean _equals = Objects.equal(it, "error");
        if (_equals) {
          Exception _exception = new Exception("this should be caught in the stream");
          _xifexpression = _exception;
        } else {
          _xifexpression = it;
        }
        return _xifexpression;
      }
    };
    Observable<Serializable> _map = promise.<Serializable>map(_function);
    final Procedure1<Serializable> _function_1 = new Procedure1<Serializable>() {
      public void apply(final Serializable it) {
        InputOutput.<String>println("this will never arrive");
      }
    };
    Subject<Serializable,Serializable> _then = PromiseExtensions.<Serializable>then(_map, _function_1);
    final Procedure1<Throwable> _function_2 = new Procedure1<Throwable>() {
      public void apply(final Throwable it) {
        InputOutput.<String>println("works correctly!");
      }
    };
    StreamExtensions.<Serializable>onError(_then, _function_2);
    StreamExtensions.<String>operator_doubleLessThan(promise, "error");
  }
  
  public Observable<String> toGreeting$(final String test) {
    ReplaySubject<String> _promise = PromiseExtensions.<String>promise(String.class);
    ReplaySubject<String> _apply = PromiseExtensions.<String>apply(_promise, test);
    final Func1<String,String> _function = new Func1<String,String>() {
      public String call(final String it) {
        return ("Welcome " + it);
      }
    };
    Observable<String> _map = _apply.<String>map(_function);
    return _map;
  }
}
