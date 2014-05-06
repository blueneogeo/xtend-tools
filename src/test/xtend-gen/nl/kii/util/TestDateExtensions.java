package nl.kii.util;

import java.util.Date;
import nl.kii.util.DateExtensions;
import nl.kii.util.Days;
import nl.kii.util.Minutes;
import nl.kii.util.Period;
import nl.kii.util.Years;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.junit.Test;

@SuppressWarnings("all")
public class TestDateExtensions {
  @Test
  public void test() {
    Date _now = DateExtensions.now();
    Minutes _mins = DateExtensions.mins(5);
    Date _minus = DateExtensions.operator_minus(_now, _mins);
    Years _years = DateExtensions.years(3);
    final Date x = DateExtensions.operator_minus(_minus, _years);
    Date _now_1 = DateExtensions.now();
    Days _days = DateExtensions.days(4);
    final Date y = DateExtensions.operator_plus(_now_1, _days);
    final Date n = DateExtensions.newest(x, y);
    InputOutput.<Date>println(n);
    Period _minus_1 = DateExtensions.operator_minus(y, x);
    Days _days_1 = DateExtensions.days(3);
    boolean _greaterThan = DateExtensions.operator_greaterThan(_minus_1, _days_1);
    InputOutput.<Boolean>println(Boolean.valueOf(_greaterThan));
  }
}