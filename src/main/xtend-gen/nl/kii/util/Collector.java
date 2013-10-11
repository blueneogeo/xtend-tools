package nl.kii.util;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import nl.kii.util.RxExtensions;
import nl.kii.util.Streamable;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.Pair;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import rx.Observable;
import rx.subjects.PublishSubject;

/**
 * Collector can collect data from various asynchronous sources.
 * <p>
 * You use it by calling the await(name) method, which gives you
 * a Procedure1 in return. The async code elsewhere can then call
 * this procedure with a result when it is ready.
 * <p>
 * AFTER creating all the await functions you need, you can listen
 * for the functions to finish with a result as an Observable.
 * You can both monitor the results coming in, as well as respond
 * to the closing of the stream using listen.onFinish [ ... ]
 * <p>
 * In the meantime, you also can asynchronously check if the
 * collector has finished using the isFinished method.
 * <p>
 * When the wait functions have finished, you can request the result
 * data of all awaited functions with the result call, which gives
 * you a map<name, value> of all values. This map also gets filled
 * as the data comes in and is a concurrent map.
 * <p>
 * The awaited functions often work great as closures. For example:
 * <p>
 * <pre>
 * val c = new Collector<JSON>
 * // perform slow async calls
 * API.loadUser(12, c.await('user'))
 * API.loadRights(45, c.await('rights'))
 * // listen to the results
 * c.listen.onFinish [
 * 		val it = c.result
 * 		println('loaded user: ' + get('user'))
 * 		println('loaded rights: ' + get('rights'))
 * ]
 * </pre>
 */
@SuppressWarnings("all")
public class Collector<T extends Object> implements Streamable<Pair<String,T>> {
  private final PublishSubject<Pair<String,T>> stream = new Function0<PublishSubject<Pair<String,T>>>() {
    public PublishSubject<Pair<String,T>> apply() {
      PublishSubject<Pair<String,T>> _newStream = RxExtensions.<Pair<String,T>>newStream();
      return _newStream;
    }
  }.apply();
  
  protected final AtomicInteger count = new Function0<AtomicInteger>() {
    public AtomicInteger apply() {
      AtomicInteger _atomicInteger = new AtomicInteger();
      return _atomicInteger;
    }
  }.apply();
  
  protected final AtomicInteger total = new Function0<AtomicInteger>() {
    public AtomicInteger apply() {
      AtomicInteger _atomicInteger = new AtomicInteger();
      return _atomicInteger;
    }
  }.apply();
  
  private final ConcurrentHashMap<String,T> data = new Function0<ConcurrentHashMap<String,T>>() {
    public ConcurrentHashMap<String,T> apply() {
      ConcurrentHashMap<String,T> _concurrentHashMap = new ConcurrentHashMap<String,T>();
      return _concurrentHashMap;
    }
  }.apply();
  
  public Collector() {
    final Procedure1<Pair<String,T>> _function = new Procedure1<Pair<String,T>>() {
        public void apply(final Pair<String,T> it) {
          String _key = it.getKey();
          T _value = it.getValue();
          Collector.this.data.put(_key, _value);
        }
      };
    RxExtensions.<Pair<String,T>>each(this.stream, _function);
  }
  
  public Procedure1<? super T> await(final String name) {
    Procedure1<T> _xblockexpression = null;
    {
      this.total.incrementAndGet();
      final Procedure1<T> _function = new Procedure1<T>() {
          public void apply(final T it) {
            Pair<String,T> _mappedTo = Pair.<String, T>of(name, it);
            RxExtensions.<Pair<String,T>>apply(Collector.this.stream, _mappedTo);
            int _incrementAndGet = Collector.this.count.incrementAndGet();
            int _get = Collector.this.total.get();
            boolean _equals = (_incrementAndGet == _get);
            if (_equals) {
              RxExtensions.<Pair<String,T>>complete(Collector.this.stream);
            }
          }
        };
      _xblockexpression = (_function);
    }
    return _xblockexpression;
  }
  
  public void collect(final String name, final T value) {
    Procedure1<? super T> _await = this.await(name);
    _await.apply(value);
  }
  
  public Observable<Pair<String,T>> stream() {
    return this.stream;
  }
  
  public ConcurrentHashMap<String,T> result() {
    return this.data;
  }
  
  public boolean isFinished() {
    int _get = this.count.get();
    int _get_1 = this.total.get();
    boolean _equals = (_get == _get_1);
    return _equals;
  }
}
