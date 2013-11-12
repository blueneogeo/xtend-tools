package nl.kii.rx;

import nl.kii.rx.PromiseExtensions;
import nl.kii.rx.StreamExtensions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.junit.Test;
import rx.Observable;
import rx.observables.ConnectableObservable;
import rx.subjects.AsyncSubject;
import rx.util.functions.Func1;

@SuppressWarnings("all")
public class TestPromiseStreamExtensions {
  @Test
  public void testRXPromise() {
    final AsyncSubject<String> promise = PromiseExtensions.<String>promise(String.class);
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
    ConnectableObservable<String> _each = StreamExtensions.<String>each(_map_1, _function_2);
    final Procedure1<Object> _function_3 = new Procedure1<Object>() {
        public void apply(final Object it) {
          InputOutput.<String>println("we are done!");
        }
      };
    ConnectableObservable<String> _onFinish = StreamExtensions.<String>onFinish(_each, _function_3);
    final Procedure1<Throwable> _function_4 = new Procedure1<Throwable>() {
        public void apply(final Throwable it) {
          String _plus = ("caught: " + it);
          InputOutput.<String>println(_plus);
        }
      };
    StreamExtensions.<String>onError(_onFinish, _function_4);
    PromiseExtensions.<String>apply(promise, "Hello!");
  }
  
  @Test
  public void testRXPromiseOperators() {
    final AsyncSubject<String> promise = PromiseExtensions.<String>promise(String.class);
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
    ConnectableObservable<String> _doubleGreaterThan = StreamExtensions.<String>operator_doubleGreaterThan(_mappedTo_1, _function_2);
    final Procedure1<Object> _function_3 = new Procedure1<Object>() {
        public void apply(final Object it) {
          InputOutput.<String>println("we are done!");
        }
      };
    ConnectableObservable<String> _upTo = StreamExtensions.<String>operator_upTo(_doubleGreaterThan, _function_3);
    final Procedure1<Throwable> _function_4 = new Procedure1<Throwable>() {
        public void apply(final Throwable it) {
          String _plus = ("caught: " + it);
          InputOutput.<String>println(_plus);
        }
      };
    StreamExtensions.<String>operator_elvis(_upTo, _function_4);
    PromiseExtensions.<String>apply(promise, "Hello!");
  }
  
  @Test
  public void testThen() {
    AsyncSubject<String> _promise = PromiseExtensions.<String>promise(String.class);
    AsyncSubject<String> _apply = PromiseExtensions.<String>apply(_promise, "Christian");
    final Function1<String,Observable<String>> _function = new Function1<String,Observable<String>>() {
        public Observable<String> apply(final String it) {
          Observable<String> _greetingAsync = TestPromiseStreamExtensions.this.toGreetingAsync(it);
          return _greetingAsync;
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
  
  public Observable<String> toGreetingAsync(final String test) {
    AsyncSubject<String> _promise = PromiseExtensions.<String>promise(String.class);
    AsyncSubject<String> _apply = PromiseExtensions.<String>apply(_promise, test);
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
