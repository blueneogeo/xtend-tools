package nl.kii.rx;

import nl.kii.rx.OptStreamExtensions;
import nl.kii.rx.StreamExtensions;
import nl.kii.util.None;
import nl.kii.util.Opt;
import nl.kii.util.OptExtensions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Test;
import rx.Observable;
import rx.subjects.PublishSubject;
import rx.subjects.Subject;

@SuppressWarnings("all")
public class TestOptStreamExtensions {
  @Test
  public void testOptStream() {
    final PublishSubject<String> stream = StreamExtensions.<String>stream(String.class);
    Observable<Opt<String>> _options = OptStreamExtensions.<String>options(stream);
    final Procedure1<String> _function = new Procedure1<String>() {
      public void apply(final String it) {
        InputOutput.<String>println(("got " + it));
      }
    };
    Observable<Opt<String>> _onSome = OptStreamExtensions.<String>onSome(_options, _function);
    final Procedure1<String> _function_1 = new Procedure1<String>() {
      public void apply(final String it) {
        InputOutput.<String>println("none");
      }
    };
    Observable<Opt<String>> _onNone = OptStreamExtensions.<String>onNone(_onSome, _function_1);
    final Procedure1<Throwable> _function_2 = new Procedure1<Throwable>() {
      public void apply(final Throwable it) {
        InputOutput.<String>println("error");
      }
    };
    OptStreamExtensions.<String>onErr(_onNone, _function_2);
    Subject<String, String> _doubleLessThan = StreamExtensions.<String>operator_doubleLessThan(stream, "hey");
    StreamExtensions.<String>operator_doubleLessThan(_doubleLessThan, "hi");
    None<String> _none = OptExtensions.<String>none();
    OptStreamExtensions.<String>apply(stream, _none);
    StreamExtensions.<String>complete(stream);
  }
  
  @Test
  public void testConditionalOptStream() {
    final PublishSubject<Integer> stream = StreamExtensions.<Integer>stream(Integer.class);
    final Function1<Integer, Boolean> _function = new Function1<Integer, Boolean>() {
      public Boolean apply(final Integer it) {
        return Boolean.valueOf(((it).intValue() < 4));
      }
    };
    Observable<Opt<Integer>> _options = OptStreamExtensions.<Integer>options(stream, _function);
    Observable<Integer> _or = OptStreamExtensions.<Integer>or(_options, Integer.valueOf(10));
    final Procedure1<Integer> _function_1 = new Procedure1<Integer>() {
      public void apply(final Integer it) {
        InputOutput.<String>println(("greater than 5: " + it));
      }
    };
    Subject<Integer, Integer> _each = StreamExtensions.<Integer>each(_or, _function_1);
    final Procedure1<Throwable> _function_2 = new Procedure1<Throwable>() {
      public void apply(final Throwable it) {
        InputOutput.<String>println(("error: " + it));
      }
    };
    Subject<Integer, Integer> _onError = StreamExtensions.<Integer>onError(_each, _function_2);
    final Procedure1<Object> _function_3 = new Procedure1<Object>() {
      public void apply(final Object it) {
        InputOutput.<String>println("I do not get called");
      }
    };
    Subject<Integer, Integer> _onComplete = StreamExtensions.<Integer>onComplete(_onError, _function_3);
    final Procedure1<Object> _function_4 = new Procedure1<Object>() {
      public void apply(final Object it) {
        InputOutput.<String>println("always finish");
      }
    };
    StreamExtensions.<Integer>onFinish(_onComplete, _function_4);
    Subject<Integer, Integer> _doubleLessThan = StreamExtensions.<Integer>operator_doubleLessThan(stream, Integer.valueOf(4));
    Subject<Integer, Integer> _doubleLessThan_1 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan, Integer.valueOf(9));
    Subject<Integer, Integer> _doubleLessThan_2 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_1, Integer.valueOf(3));
    Subject<Integer, Integer> _doubleLessThan_3 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_2, Integer.valueOf(0));
    Subject<Integer, Integer> _doubleLessThan_4 = StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_3, Integer.valueOf(5));
    Exception _exception = new Exception();
    StreamExtensions.<Integer>operator_doubleLessThan(_doubleLessThan_4, _exception);
    StreamExtensions.<Integer>complete(stream);
  }
}
