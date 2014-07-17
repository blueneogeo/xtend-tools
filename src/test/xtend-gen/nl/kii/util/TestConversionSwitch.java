package nl.kii.util;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import nl.kii.util.IterableExtensions;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Pair;
import org.junit.Assert;
import org.junit.Test;

@SuppressWarnings("all")
public class TestConversionSwitch {
  @Test
  public void testSwitch() {
    final List<Integer> list = Collections.<Integer>unmodifiableList(CollectionLiterals.<Integer>newArrayList(Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3)));
    Pair<Integer, String> _mappedTo = Pair.<Integer, String>of(Integer.valueOf(1), "A");
    Pair<Integer, String> _mappedTo_1 = Pair.<Integer, String>of(Integer.valueOf(2), "B");
    final Map<Integer, String> map = Collections.<Integer, String>unmodifiableMap(CollectionLiterals.<Integer, String>newHashMap(_mappedTo, _mappedTo_1));
    boolean _matched = false;
    if (!_matched) {
      boolean _isListOf = IterableExtensions.isListOf(list, Integer.class);
      if (_isListOf) {
        _matched=true;
      }
    }
    if (!_matched) {
      boolean _isListOf_1 = IterableExtensions.isListOf(list, String.class);
      if (_isListOf_1) {
        _matched=true;
        Assert.fail("not a list of a string");
      }
    }
    if (!_matched) {
      Assert.fail("no match found for list");
    }
    boolean _matched_1 = false;
    if (!_matched_1) {
      boolean _isMapOf = IterableExtensions.isMapOf(map, Integer.class, String.class);
      if (_isMapOf) {
        _matched_1=true;
      }
    }
    if (!_matched_1) {
      boolean _isMapOf_1 = IterableExtensions.isMapOf(map, String.class, String.class);
      if (_isMapOf_1) {
        _matched_1=true;
        Assert.fail("not map of string->string");
      }
    }
    if (!_matched_1) {
      Assert.fail("no match found for map");
    }
  }
}
