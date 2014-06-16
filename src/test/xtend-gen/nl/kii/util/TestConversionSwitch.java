package nl.kii.util;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import nl.kii.util.IterableExtensions;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.junit.Assert;
import org.junit.Test;

@SuppressWarnings("all")
public class TestConversionSwitch {
  @Test
  public void testSwitch() {
    final List<Integer> list = Collections.<Integer>unmodifiableList(Lists.<Integer>newArrayList(Integer.valueOf(1), Integer.valueOf(2), Integer.valueOf(3)));
    Map<Integer, String> _xsetliteral = null;
    Map<Integer, String> _tempMap = Maps.<Integer, String>newHashMap();
    _tempMap.put(Integer.valueOf(1), "A");
    _tempMap.put(Integer.valueOf(2), "B");
    _xsetliteral = Collections.<Integer, String>unmodifiableMap(_tempMap);
    final Map<Integer, String> map = _xsetliteral;
    boolean _matched = false;
    if (!_matched) {
      boolean _isListOf = IterableExtensions.isListOf(list, Integer.class);
      if (_isListOf) {
        _matched=true;
        InputOutput.<String>println("list ok");
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
        InputOutput.<String>println("map ok");
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
