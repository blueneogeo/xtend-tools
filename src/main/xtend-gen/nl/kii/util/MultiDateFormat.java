package nl.kii.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ListExtensions;

@SuppressWarnings("all")
public class MultiDateFormat {
  private final List<DateFormat> dateFormats;
  
  private final Locale locale;
  
  public MultiDateFormat(final String dateFormat, final Locale locale) {
    String[] _split = dateFormat.split("\\;\\s");
    final Function1<String, DateFormat> _function = new Function1<String, DateFormat>() {
      public DateFormat apply(final String it) {
        return new SimpleDateFormat(it, Locale.ENGLISH);
      }
    };
    List<DateFormat> _map = ListExtensions.<String, DateFormat>map(((List<String>)Conversions.doWrapArray(_split)), _function);
    this.dateFormats = _map;
    this.locale = locale;
  }
  
  public Date parse(final String string) {
    try {
      Date _xblockexpression = null;
      {
        final Function1<DateFormat, Boolean> _function = new Function1<DateFormat, Boolean>() {
          public Boolean apply(final DateFormat it) {
            return Boolean.valueOf(MultiDateFormat.this.matches(string, it));
          }
        };
        final DateFormat possibleValidFormat = IterableExtensions.<DateFormat>findFirst(this.dateFormats, _function);
        DateFormat _elvis = null;
        if (possibleValidFormat != null) {
          _elvis = possibleValidFormat;
        } else {
          DateFormat _head = IterableExtensions.<DateFormat>head(this.dateFormats);
          _elvis = _head;
        }
        _xblockexpression = _elvis.parse(string);
      }
      return _xblockexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public String format(final Date date) {
    final Function1<DateFormat, Boolean> _function = new Function1<DateFormat, Boolean>() {
      public Boolean apply(final DateFormat it) {
        return Boolean.valueOf(MultiDateFormat.this.matches(date, it));
      }
    };
    DateFormat _findFirst = IterableExtensions.<DateFormat>findFirst(this.dateFormats, _function);
    return _findFirst.format(date);
  }
  
  public boolean matches(final Object input, final DateFormat format) {
    boolean _xtrycatchfinallyexpression = false;
    try {
      boolean _xblockexpression = false;
      {
        final Object it = input;
        boolean _matched = false;
        if (!_matched) {
          if (it instanceof String) {
            _matched=true;
            format.parse(((String)it));
          }
        }
        if (!_matched) {
          if (it instanceof Date) {
            _matched=true;
            format.format(((Date)it));
          }
        }
        _xblockexpression = true;
      }
      _xtrycatchfinallyexpression = _xblockexpression;
    } catch (final Throwable _t) {
      if (_t instanceof ParseException) {
        final ParseException e = (ParseException)_t;
        _xtrycatchfinallyexpression = false;
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    return _xtrycatchfinallyexpression;
  }
}
