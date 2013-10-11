package nl.kii.util;

import java.util.Collection;
import java.util.concurrent.ConcurrentHashMap;
import nl.kii.util.Collector;
import org.eclipse.xtext.xbase.lib.Functions.Function2;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;

/**
 * Countdown is a specialized version of Collector that collects
 * if various functions have been executed successfully. You can
 * call await with a name like a collector or without a name, in
 * which case the name will be a number. The result function takes
 * a true/false based on whether the async code was successful.
 * <p>
 * You can ask if all functions were successful by calling isSuccess
 * <p>
 * Example code:
 * <p>
 * <pre>
 * val c = new Countdown
 * // create waiting functions
 * val signal1 = c.await
 * val signal2 = c.await
 * // finish when both async waiting functions complete
 * c.listen.onFinish [ println('both code functions ran. success: ' + c.success) ]
 * // sometime later, the signal functions are applied
 * [| ... some code .... signal1.apply(true) .... ].scheduleLater
 * [|... some other async code... signal2.apply(true) ...].scheduleLater
 * </pre>
 */
@SuppressWarnings("all")
public class Countdown extends Collector<Boolean> {
  public Procedure1<? super Boolean> await() {
    int _get = this.total.get();
    String _string = Integer.valueOf(_get).toString();
    Procedure1<? super Boolean> _await = super.await(_string);
    return _await;
  }
  
  public Boolean isSuccess() {
    ConcurrentHashMap<String,Boolean> _result = this.result();
    Collection<Boolean> _values = _result.values();
    final Function2<Boolean,Boolean,Boolean> _function = new Function2<Boolean,Boolean,Boolean>() {
        public Boolean apply(final Boolean a, final Boolean b) {
          boolean _and = false;
          if (!(a).booleanValue()) {
            _and = false;
          } else {
            _and = ((a).booleanValue() && (b).booleanValue());
          }
          return Boolean.valueOf(_and);
        }
      };
    Boolean _reduce = IterableExtensions.<Boolean>reduce(_values, _function);
    return _reduce;
  }
}
