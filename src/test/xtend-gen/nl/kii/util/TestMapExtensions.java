package nl.kii.util;

import java.util.Collections;
import java.util.Map;
import nl.kii.util.MapExtensions;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Functions.Function2;
import org.eclipse.xtext.xbase.lib.Pair;
import org.junit.Assert;
import org.junit.Test;

@SuppressWarnings("all")
public class TestMapExtensions {
  @Test
  public void testMapMapping() {
    Pair<Integer, Integer> _mappedTo = Pair.<Integer, Integer>of(Integer.valueOf(1), Integer.valueOf(5));
    Pair<Integer, Integer> _mappedTo_1 = Pair.<Integer, Integer>of(Integer.valueOf(2), Integer.valueOf(6));
    final Function2<Integer, Integer, Pair<Integer, Integer>> _function = new Function2<Integer, Integer, Pair<Integer, Integer>>() {
      @Override
      public Pair<Integer, Integer> apply(final Integer k, final Integer v) {
        return Pair.<Integer, Integer>of(Integer.valueOf(((k).intValue() + 1)), Integer.valueOf(((v).intValue() + 1)));
      }
    };
    Map<Integer, Integer> _map = MapExtensions.<Integer, Integer, Integer, Integer>map(Collections.<Integer, Integer>unmodifiableMap(CollectionLiterals.<Integer, Integer>newHashMap(_mappedTo, _mappedTo_1)), _function);
    Pair<Integer, Integer> _mappedTo_2 = Pair.<Integer, Integer>of(Integer.valueOf(2), Integer.valueOf(6));
    Pair<Integer, Integer> _mappedTo_3 = Pair.<Integer, Integer>of(Integer.valueOf(3), Integer.valueOf(7));
    Assert.assertEquals(_map, Collections.<Integer, Integer>unmodifiableMap(CollectionLiterals.<Integer, Integer>newHashMap(_mappedTo_2, _mappedTo_3)));
  }
}
