package nl.kii.util;

import java.util.Map;
import nl.kii.util.PartialURL;
import org.junit.Assert;
import org.junit.Test;

@SuppressWarnings("all")
public class TestPartialURL {
  @Test
  public void testURLParsing() {
    final String text = "http://www.test.com/somepath/to/nowhere?p1=10&p2=hello#somehash:somewhere";
    final PartialURL url = new PartialURL(text);
    String _string = url.toString();
    Assert.assertEquals(text, _string);
    Map<String, String> _parameters = url.getParameters();
    String _get = _parameters.get("p1");
    Assert.assertEquals("10", _get);
    Map<String, String> _parameters_1 = url.getParameters();
    String _get_1 = _parameters_1.get("p2");
    Assert.assertEquals("hello", _get_1);
    boolean _isValid = url.isValid();
    Assert.assertTrue(_isValid);
  }
  
  @Test
  public void testBadURL() {
    final String text = "just a test";
    boolean _isValid = PartialURL.isValid(text);
    Assert.assertFalse(_isValid);
  }
  
  @Test
  public void testNoParametersGiveEmptyQueryParameters() {
    final PartialURL url = new PartialURL("/twitter/timeline?telegraaf");
    Map<String, String> _parameters = url.getParameters();
    boolean _isEmpty = _parameters.isEmpty();
    Assert.assertTrue(_isEmpty);
  }
}
