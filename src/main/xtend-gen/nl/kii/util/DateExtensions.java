package nl.kii.util;

import com.google.common.base.Objects;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;
import nl.kii.util.Days;
import nl.kii.util.Hours;
import nl.kii.util.MilliSeconds;
import nl.kii.util.Minutes;
import nl.kii.util.Period;
import nl.kii.util.Seconds;
import nl.kii.util.Years;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ListExtensions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;

@SuppressWarnings("all")
public class DateExtensions {
  private final static String standardDateFormat = "yyyy-MM-dd\'T\'HH:mm:ss";
  
  /**
   * The current date
   */
  public static Date now() {
    return new Date();
  }
  
  /**
   * Convert a date to UTC timezone
   */
  public static Date toUTC(final Date date) {
    Date _xblockexpression = null;
    {
      final Calendar cal = DateExtensions.toCalendar(date);
      int _get = cal.get(Calendar.DST_OFFSET);
      int _get_1 = cal.get(Calendar.ZONE_OFFSET);
      int _plus = (_get + _get_1);
      int _get_2 = cal.get(Calendar.DST_OFFSET);
      int _minus = (_plus - _get_2);
      Period _period = new Period(_minus);
      _xblockexpression = DateExtensions.operator_minus(date, _period);
    }
    return _xblockexpression;
  }
  
  public static Date toTimeZone(final Date date, final String zone) {
    Date _uTC = DateExtensions.toUTC(date);
    TimeZone _timeZone = TimeZone.getTimeZone(zone);
    int _rawOffset = _timeZone.getRawOffset();
    Period _period = new Period(_rawOffset);
    return DateExtensions.operator_plus(_uTC, _period);
  }
  
  public static int getCurrentMinute(final Date date) {
    Calendar _calendar = DateExtensions.toCalendar(date);
    return _calendar.get(Calendar.MINUTE);
  }
  
  public static int getCurrentSecond(final Date date) {
    Calendar _calendar = DateExtensions.toCalendar(date);
    return _calendar.get(Calendar.SECOND);
  }
  
  public static int getHourOfDay(final Date date) {
    Calendar _calendar = DateExtensions.toCalendar(date);
    return _calendar.get(Calendar.HOUR_OF_DAY);
  }
  
  public static Calendar toCalendar(final Date date) {
    Calendar _instance = Calendar.getInstance();
    final Procedure1<Calendar> _function = new Procedure1<Calendar>() {
      public void apply(final Calendar it) {
        it.setTime(date);
      }
    };
    return ObjectExtensions.<Calendar>operator_doubleArrow(_instance, _function);
  }
  
  /**
   * quickly format a date to the standard "yyyy-MM-dd'T'HH:mm:ss" format.
   */
  public static String format(final Date date) {
    SimpleDateFormat _simpleDateFormat = new SimpleDateFormat(DateExtensions.standardDateFormat);
    return _simpleDateFormat.format(date);
  }
  
  /**
   * quickly format a date to a specified format. see all formatting options at
   * http://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html
   */
  public static String format(final Date date, final String format) {
    SimpleDateFormat _simpleDateFormat = new SimpleDateFormat(format);
    return _simpleDateFormat.format(date);
  }
  
  /**
   * Return the most recent date
   */
  public static Date newest(final Date... dates) {
    final Function1<Date, Boolean> _function = new Function1<Date, Boolean>() {
      @Override
      public Boolean apply(final Date it) {
        return Boolean.valueOf((!Objects.equal(it, null)));
      }
    };
    Iterable<Date> _filter = IterableExtensions.<Date>filter(((Iterable<Date>)Conversions.doWrapArray(dates)), _function);
    final Function1<Date, Long> _function_1 = new Function1<Date, Long>() {
      @Override
      public Long apply(final Date it) {
        return Long.valueOf(it.getTime());
      }
    };
    List<Date> _sortBy = IterableExtensions.<Date, Long>sortBy(_filter, _function_1);
    List<Date> _reverse = ListExtensions.<Date>reverse(_sortBy);
    return IterableExtensions.<Date>head(_reverse);
  }
  
  /**
   * Return the oldest date
   */
  public static Date oldest(final Date... dates) {
    final Function1<Date, Boolean> _function = new Function1<Date, Boolean>() {
      @Override
      public Boolean apply(final Date it) {
        return Boolean.valueOf((!Objects.equal(it, null)));
      }
    };
    Iterable<Date> _filter = IterableExtensions.<Date>filter(((Iterable<Date>)Conversions.doWrapArray(dates)), _function);
    final Function1<Date, Long> _function_1 = new Function1<Date, Long>() {
      @Override
      public Long apply(final Date it) {
        return Long.valueOf(it.getTime());
      }
    };
    List<Date> _sortBy = IterableExtensions.<Date, Long>sortBy(_filter, _function_1);
    return IterableExtensions.<Date>head(_sortBy);
  }
  
  /**
   * See if a date is older than a given period (since right now)
   */
  public static boolean isOlderThan(final Date date, final Period period) {
    Date _now = DateExtensions.now();
    Period _minus = DateExtensions.operator_minus(_now, date);
    return DateExtensions.operator_greaterThan(_minus, period);
  }
  
  /**
   * the date is more than [period] old
   */
  public static boolean operator_greaterThan(final Date date, final Period period) {
    Date _now = DateExtensions.now();
    Period _minus = DateExtensions.operator_minus(_now, date);
    return DateExtensions.operator_greaterThan(_minus, period);
  }
  
  /**
   * the date is more or equals than [period] old
   */
  public static boolean operator_greaterEqualsThan(final Date date, final Period period) {
    Date _now = DateExtensions.now();
    Period _minus = DateExtensions.operator_minus(_now, date);
    return DateExtensions.operator_greaterEqualsThan(_minus, period);
  }
  
  /**
   * the date is less than [period] old
   */
  public static boolean operator_lessThan(final Date date, final Period period) {
    Date _now = DateExtensions.now();
    Period _minus = DateExtensions.operator_minus(_now, date);
    return DateExtensions.operator_lessThan(_minus, period);
  }
  
  /**
   * the date is less or equals than [period] old
   */
  public static boolean operator_lessEqualsThan(final Date date, final Period period) {
    Date _now = DateExtensions.now();
    Period _minus = DateExtensions.operator_minus(_now, date);
    return DateExtensions.operator_lessEqualsThan(_minus, period);
  }
  
  /**
   * Difference between dates, largest first
   */
  public static Period diff(final Date d1, final Date d2) {
    long _time = d1.getTime();
    long _time_1 = d2.getTime();
    long _minus = (_time - _time_1);
    return new Period(_minus);
  }
  
  public static Period operator_minus(final Date d1, final Date d2) {
    return DateExtensions.diff(d1, d2);
  }
  
  public static Period add(final Period p1, final Period p2) {
    long _time = p1.time();
    long _time_1 = p2.time();
    long _plus = (_time + _time_1);
    return new Period(_plus);
  }
  
  public static Period subtract(final Period p1, final Period p2) {
    long _time = p1.time();
    long _time_1 = p2.time();
    long _minus = (_time - _time_1);
    return new Period(_minus);
  }
  
  public static Period operator_plus(final Period p1, final Period p2) {
    return DateExtensions.add(p1, p2);
  }
  
  public static Period operator_minus(final Period p1, final Period p2) {
    return DateExtensions.subtract(p1, p2);
  }
  
  public static Period divide(final Period p1, final int amount) {
    long _time = p1.time();
    long _divide = (_time / amount);
    return new Period(_divide);
  }
  
  public static Period operator_divide(final Period p1, final int amount) {
    return DateExtensions.divide(p1, amount);
  }
  
  public static Date add(final Date date, final Period p) {
    long _time = date.getTime();
    long _time_1 = p.time();
    long _plus = (_time + _time_1);
    return new Date(_plus);
  }
  
  public static Date subtract(final Date date, final Period p) {
    long _time = date.getTime();
    long _time_1 = p.time();
    long _minus = (_time - _time_1);
    return new Date(_minus);
  }
  
  public static Date operator_plus(final Date date, final Period p) {
    return DateExtensions.add(date, p);
  }
  
  public static Date operator_minus(final Date date, final Period p) {
    return DateExtensions.subtract(date, p);
  }
  
  public static boolean operator_greaterThan(final Period p1, final Period p2) {
    long _time = p1.time();
    long _time_1 = p2.time();
    return (_time > _time_1);
  }
  
  public static boolean operator_greaterEqualsThan(final Period p1, final Period p2) {
    long _time = p1.time();
    long _time_1 = p2.time();
    return (_time >= _time_1);
  }
  
  public static boolean operator_lessThan(final Period p1, final Period p2) {
    long _time = p1.time();
    long _time_1 = p2.time();
    return (_time < _time_1);
  }
  
  public static boolean operator_lessEqualsThan(final Period p1, final Period p2) {
    long _time = p1.time();
    long _time_1 = p2.time();
    return (_time <= _time_1);
  }
  
  public static MilliSeconds ms(final long value) {
    return new MilliSeconds(value);
  }
  
  public static Seconds secs(final long value) {
    return new Seconds(value);
  }
  
  public static Minutes mins(final long value) {
    return new Minutes(value);
  }
  
  public static Hours hours(final long value) {
    return new Hours(value);
  }
  
  public static Days days(final long value) {
    return new Days(value);
  }
  
  public static Years years(final long value) {
    return new Years(value);
  }
}
