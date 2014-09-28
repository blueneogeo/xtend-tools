package nl.kii.util;

import java.util.Map;
import nl.kii.util.URL;
import org.junit.Assert;
import org.junit.Test;

@SuppressWarnings("all")
public class TestURL {
  @Test
  public void testURLParsing() {
    final String text = "http://www.test.com/somepath/to/nowhere?p1=10&p2=hello#somehash:somewhere";
    final URL url = new URL(text);
    String _string = url.toString();
    Assert.assertEquals(text, _string);
    Map<String, String> _parameters = url.getParameters();
    String _get = _parameters.get("p1");
    Assert.assertEquals("10", _get);
    Map<String, String> _parameters_1 = url.getParameters();
    String _get_1 = _parameters_1.get("p2");
    Assert.assertEquals("hello", _get_1);
    boolean _isValid = URL.isValid(text);
    Assert.assertTrue(_isValid);
  }
  
  @Test
  public void testBadURL() {
    final String text = "just a test";
    boolean _isValid = URL.isValid(text);
    Assert.assertFalse(_isValid);
  }
}
