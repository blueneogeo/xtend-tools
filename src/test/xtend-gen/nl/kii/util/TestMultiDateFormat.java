package nl.kii.util;

import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import nl.kii.util.MultiDateFormat;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.junit.Test;

@SuppressWarnings("all")
public class TestMultiDateFormat {
  private final List<String> someDateStrings = Collections.<String>unmodifiableList(CollectionLiterals.<String>newArrayList("Thu, 30 Oct 2014 15:35:13 +01:00", "Thu, 30 Oct 2014 15:35:13 +0100", "Thu, 30 Oct 2014 15:35:13 CET"));
  
  @Test
  public void textMultipleInputs() {
    final Procedure1<String> _function = new Procedure1<String>() {
      public void apply(final String it) {
        final Date date = TestMultiDateFormat.this.toDate(it, "EEE, d MMM yyyy HH:mm:ss z; EEE, d MMM yyyy HH:mm:ss X");
        InputOutput.<Date>println(date);
        SimpleDateFormat _simpleDateFormat = new SimpleDateFormat("dd-MM-yyyy");
        String _format = _simpleDateFormat.format(date);
        Assert.assertEquals(_format, "30-10-2014");
      }
    };
    IterableExtensions.<String>forEach(this.someDateStrings, _function);
  }
  
  @Test
  public void testSingleInput() {
    final Date date = this.toDate("Thu, 30 Oct 2014 15:35:13 +0100", "EEE, d MMM yyyy HH:mm:ss z");
    InputOutput.<Date>println(date);
    String _string = date.toString();
    Assert.assertEquals(_string, "Thu Oct 30 15:35:13 CET 2014");
  }
  
  public Date toDate(final String s, final String dateFormat) {
    MultiDateFormat _multiDateFormat = new MultiDateFormat(dateFormat, Locale.ENGLISH);
    return _multiDateFormat.parse(s);
  }
}
