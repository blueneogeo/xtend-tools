package nl.kii.rx;

import nl.kii.rx.PromiseExtensions;
import nl.kii.rx.StreamExtensions;
import nl.kii.rx.Subscriber;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.junit.Test;
import rx.Observable;
import rx.subjects.ReplaySubject;
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
          String _plus = ("Hey cool I got this text: " + it);
          return _plus;
        }
      };
    Observable<String> _map_1 = _map.<String>map(_function_1);
    final Procedure1<String> _function_2 = new Procedure1<String>() {
        public void apply(final String it) {
          InputOutput.<String>println(it);
        }
      };
    Subscriber<String> _each = StreamExtensions.<String>each(_map_1, _function_2);
    final Procedure1<Object> _function_3 = new Procedure1<Object>() {
        public void apply(final Object it) {
          InputOutput.<String>println("we are done!");
        }
      };
    Subscriber<String> _onFinish = _each.onFinish(_function_3);
    final Procedure1<Throwable> _function_4 = new Procedure1<Throwable>() {
        public void apply(final Throwable it) {
          String _plus = ("caught: " + it);
          InputOutput.<String>println(_plus);
        }
      };
    Subscriber<String> _onError = _onFinish.onError(_function_4);
    _onError.start();
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
          String _plus = ("Hey cool I got this text: " + it);
          return _plus;
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
  public void testThen() {
    ReplaySubject<String> _promise = PromiseExtensions.<String>promise(String.class);
    ReplaySubject<String> _apply = PromiseExtensions.<String>apply(_promise, "Christian");
    final Function1<String,Observable<String>> _function = new Function1<String,Observable<String>>() {
        public Observable<String> apply(final String it) {
          Observable<String> _greeting$ = TestPromiseStreamExtensions.this.toGreeting$(it);
          return _greeting$;
        }
      };
    Observable<String> _then = PromiseExtensions.<String, String>then(_apply, _function);
    final Procedure1<String> _function_1 = new Procedure1<String>() {
        public void apply(final String it) {
          Assert.assertEquals(it, "Welcome Christian");
        }
      };
    PromiseExtensions.<String>then(_then, _function_1);
  }
  
  public Observable<String> toGreeting$(final String test) {
    ReplaySubject<String> _promise = PromiseExtensions.<String>promise(String.class);
    ReplaySubject<String> _apply = PromiseExtensions.<String>apply(_promise, test);
    final Func1<String,String> _function = new Func1<String,String>() {
        public String call(final String it) {
          String _plus = ("Welcome " + it);
          return _plus;
        }
      };
    Observable<String> _map = _apply.<String>map(_function);
    return _map;
  }
}
