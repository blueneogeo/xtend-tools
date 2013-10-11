package nl.kii.util;

import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import nl.kii.util.ObserverHelper;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure0;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import rx.Observable;
import rx.Observer;
import rx.Scheduler;
import rx.observables.ConnectableObservable;
import rx.subjects.AsyncSubject;
import rx.subjects.PublishSubject;
import rx.util.functions.Action1;

@SuppressWarnings("all")
public class RxExtensions {
  public static <T extends Object> PublishSubject<T> newStream() {
    PublishSubject<T> _create = PublishSubject.<T>create();
    return _create;
  }
  
  public static <T extends Object> PublishSubject<T> stream(final Class<T> type) {
    PublishSubject<T> _create = PublishSubject.<T>create();
    return _create;
  }
  
  public static <T extends Object> PublishSubject<T> stream(final T instance) {
    PublishSubject<T> _create = PublishSubject.<T>create();
    return _create;
  }
  
  public static <T extends Object> Observable<T> stream(final Iterable<? extends T> iterable) {
    Observable<T> _from = Observable.<T>from(iterable);
    return _from;
  }
  
  /**
   * Create a new Observable from the passed Observable (stream). Internally it creates a
   * ConnectableObservable<T>, connects it, and returns it.
   * <p>
   * This allows you to split a stream into multiple streams:
   * <pre>
   * stream => [
   * 		split.each [ println('1st stream got ' + it) ]
   * 		split.each [ println('2nd stream also got ' + it) ]
   * ]
   * </pre>
   */
  public static <T extends Object> ConnectableObservable<T> split(final Observable<T> stream) {
    ConnectableObservable<T> _xblockexpression = null;
    {
      final ConnectableObservable<T> connector = stream.publish();
      connector.connect();
      _xblockexpression = (connector);
    }
    return _xblockexpression;
  }
  
  public static <T extends Object> AsyncSubject<T> newPromise() {
    AsyncSubject<T> _create = AsyncSubject.<T>create();
    return _create;
  }
  
  public static <T extends Object> AsyncSubject<T> promise(final Class<T> type) {
    AsyncSubject<T> _create = AsyncSubject.<T>create();
    return _create;
  }
  
  public static <T extends Object> Observable<T> promise(final T item) {
    Observable<T> _from = Observable.<T>from(item);
    return _from;
  }
  
  public static <T extends Object> Observable<T> promise(final T item, final Observer<T> observer) {
    Observable<T> _promise = RxExtensions.<T>promise(item);
    Observable<T> _each = RxExtensions.<T>each(_promise, observer);
    return _each;
  }
  
  public static <T extends Object> Observable<T> promise(final Future<? extends Object> future, final Class<T> type) {
    Observable<T> _from = Observable.<T>from(((Future<T>) future));
    return _from;
  }
  
  public static <T extends Object> Observable<T> promise(final Future<? extends T> future, final Scheduler scheduler) {
    Observable<T> _from = Observable.<T>from(future, scheduler);
    return _from;
  }
  
  public static <T extends Object> Observable<T> promise(final Future<? extends T> future, final long timeout, final TimeUnit timeUnit) {
    Observable<T> _from = Observable.<T>from(future, timeout, timeUnit);
    return _from;
  }
  
  public static <T extends Object> Observer<T> apply(final Observer<T> stream, final T value) {
    Observer<T> _xblockexpression = null;
    {
      stream.onNext(value);
      _xblockexpression = (stream);
    }
    return _xblockexpression;
  }
  
  public static <T extends Object> void complete(final PublishSubject<T> subject) {
    subject.onCompleted();
  }
  
  public static <T extends Object> Iterable<? extends T> each(final Iterable<? extends T> iterable, final Observer<T> observer) {
    Iterable<? extends T> _xblockexpression = null;
    {
      final Procedure1<T> _function = new Procedure1<T>() {
          public void apply(final T it) {
            observer.onNext(it);
          }
        };
      IterableExtensions.forEach(iterable, _function);
      _xblockexpression = (iterable);
    }
    return _xblockexpression;
  }
  
  public static <T extends Object> AsyncSubject<T> apply(final AsyncSubject<T> subject, final T value) {
    AsyncSubject<T> _xblockexpression = null;
    {
      subject.onNext(value);
      subject.onCompleted();
      _xblockexpression = (subject);
    }
    return _xblockexpression;
  }
  
  public static <T extends Object> Observable<T> each(final Observable<T> stream, final Procedure1<? super T> handler) {
    Observable<T> _xblockexpression = null;
    {
      stream.subscribe(new Action1<T>() {
          public void call(T t1) {
            handler.apply(t1);
          }
      });
      _xblockexpression = (stream);
    }
    return _xblockexpression;
  }
  
  public static <T extends Object> Observable<T> each(final Observable<T> stream, final Observer<T> observer) {
    Observable<T> _xblockexpression = null;
    {
      stream.subscribe(observer);
      _xblockexpression = (stream);
    }
    return _xblockexpression;
  }
  
  public static <T extends Object> Observable<T> onError(final Observable<T> stream, final Procedure1<? super Throwable> handler) {
    Observable<T> _xblockexpression = null;
    {
      final Procedure1<T> _function = new Procedure1<T>() {
          public void apply(final T it) {
          }
        };
      final Procedure0 _function_1 = new Procedure0() {
          public void apply() {
          }
        };
      ObserverHelper<T> _observerHelper = new ObserverHelper<T>(_function, handler, _function_1);
      stream.subscribe(_observerHelper);
      _xblockexpression = (stream);
    }
    return _xblockexpression;
  }
  
  public static <T extends Object> Observable<T> onFinish(final Observable<T> stream, final Procedure1<? super Object> handler) {
    Observable<T> _xblockexpression = null;
    {
      final Procedure1<T> _function = new Procedure1<T>() {
          public void apply(final T it) {
          }
        };
      final Procedure1<Throwable> _function_1 = new Procedure1<Throwable>() {
          public void apply(final Throwable it) {
          }
        };
      final Procedure0 _function_2 = new Procedure0() {
          public void apply() {
            handler.apply(null);
          }
        };
      ObserverHelper<T> _observerHelper = new ObserverHelper<T>(_function, _function_1, _function_2);
      stream.subscribe(_observerHelper);
      _xblockexpression = (stream);
    }
    return _xblockexpression;
  }
}
