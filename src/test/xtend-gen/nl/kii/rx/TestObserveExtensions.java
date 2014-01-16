package nl.kii.rx;

import nl.kii.rx.ObserveExtensions;
import nl.kii.rx.ObservedValue;
import nl.kii.rx.StreamExtensions;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.junit.Test;

@SuppressWarnings("all")
public class TestObserveExtensions {
  @Test
  public void testObserved() {
    final ObservedValue<Integer> counter = ObserveExtensions.<Integer>observe(Integer.valueOf(0));
    Integer _apply = counter.apply();
    Assert.assertEquals((_apply).intValue(), 0);
    final Procedure1<Integer> _function = new Procedure1<Integer>() {
      public void apply(final Integer it) {
        InputOutput.<String>println("counter was changed! << will be called twice");
      }
    };
    StreamExtensions.<Integer>each(counter, _function);
    StreamExtensions.<Integer>operator_doubleLessThan(counter, Integer.valueOf(5));
    Integer _get = counter.get();
    Assert.assertEquals((_get).intValue(), 5);
  }
  
  @Test
  public void testComputedObserved() {
    final ObservedValue<Integer> v1 = ObserveExtensions.<Integer>observe(Integer.valueOf(10));
    final ObservedValue<Integer> v2 = ObserveExtensions.<Integer>observe(Integer.valueOf(40));
    final Function0<Integer> _function = new Function0<Integer>() {
      public Integer apply() {
        Integer _get = v1.get();
        Integer _get_1 = v2.get();
        return ((_get).intValue() + (_get_1).intValue());
      }
    };
    final ObservedValue<Integer> v3 = ObserveExtensions.<Integer>observe(_function, v1, v2);
    StreamExtensions.<Integer>operator_doubleLessThan(v1, Integer.valueOf(30));
    Integer _get = v3.get();
    Assert.assertEquals((_get).intValue(), (30 + 40));
    final Procedure1<Integer> _function_1 = new Procedure1<Integer>() {
      public void apply(final Integer it) {
        InputOutput.<String>println(("v3 changed to " + it));
      }
    };
    StreamExtensions.<Integer>each(v3, _function_1);
    StreamExtensions.<Integer>operator_doubleLessThan(v2, Integer.valueOf(90));
    Integer _get_1 = v3.get();
    Assert.assertEquals((_get_1).intValue(), (30 + 90));
  }
}
