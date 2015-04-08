package nl.kii.util;

import java.util.List;
import java.util.function.Consumer;
import nl.kii.util.Log;
import nl.kii.util.OptExtensions;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.slf4j.Logger;

@SuppressWarnings("all")
public class LogExtensions {
  public static Log wrapper(final Logger logger) {
    return new Log(logger, null);
  }
  
  public static Log wrapper(final Logger logger, final String name) {
    return new Log(logger, name);
  }
  
  public static void print(final CharSequence... s) {
    final Consumer<CharSequence> _function = new Consumer<CharSequence>() {
      @Override
      public void accept(final CharSequence it) {
        InputOutput.<CharSequence>println(it);
      }
    };
    ((List<CharSequence>)Conversions.doWrapArray(s)).forEach(_function);
  }
  
  public static <T extends Object> T print(final Function0<? extends T> s) {
    T _apply = s.apply();
    return InputOutput.<T>println(_apply);
  }
  
  public static <T extends Object> T print(final Function1<? super Object, ? extends T> o) {
    T _apply = o.apply(null);
    return InputOutput.<T>print(_apply);
  }
  
  public static <T extends Object> Procedure1<? super T> printEach() {
    final Procedure1<T> _function = new Procedure1<T>() {
      @Override
      public void apply(final T it) {
        InputOutput.<T>println(it);
      }
    };
    return _function;
  }
  
  public static <T extends Object> Procedure1<? super T> printEach(final String msg) {
    final Procedure1<T> _function = new Procedure1<T>() {
      @Override
      public void apply(final T it) {
        InputOutput.<String>println((msg + it));
      }
    };
    return _function;
  }
  
  public static <T extends Object> void printEach(final Iterable<T> list, final String msg) {
    boolean _defined = OptExtensions.<Object>defined(msg);
    if (_defined) {
      InputOutput.<String>println(msg);
    }
    final Consumer<T> _function = new Consumer<T>() {
      @Override
      public void accept(final T it) {
        String _logEntry = LogExtensions.getLogEntry(it);
        InputOutput.<String>println(_logEntry);
      }
    };
    list.forEach(_function);
  }
  
  public static <T extends Object> void trace(final Iterable<T> list, final String msg, final Log log) {
    boolean _defined = OptExtensions.<Object>defined(msg);
    if (_defined) {
      log.logger.trace(msg);
    }
    final Consumer<T> _function = new Consumer<T>() {
      @Override
      public void accept(final T it) {
        Logger _logger = log.getLogger();
        String _logEntry = LogExtensions.getLogEntry(it);
        _logger.trace(_logEntry);
      }
    };
    list.forEach(_function);
  }
  
  public static <T extends Object> void debug(final Iterable<T> list, final String msg, final Log log) {
    boolean _defined = OptExtensions.<Object>defined(msg);
    if (_defined) {
      log.logger.debug(msg);
    }
    final Consumer<T> _function = new Consumer<T>() {
      @Override
      public void accept(final T it) {
        Logger _logger = log.getLogger();
        String _logEntry = LogExtensions.getLogEntry(it);
        _logger.debug(_logEntry);
      }
    };
    list.forEach(_function);
  }
  
  public static <T extends Object> void info(final Iterable<T> list, final String msg, final Log log) {
    boolean _defined = OptExtensions.<Object>defined(msg);
    if (_defined) {
      log.logger.info(msg);
    }
    final Consumer<T> _function = new Consumer<T>() {
      @Override
      public void accept(final T it) {
        Logger _logger = log.getLogger();
        String _logEntry = LogExtensions.getLogEntry(it);
        _logger.info(_logEntry);
      }
    };
    list.forEach(_function);
  }
  
  public static <T extends Object> void warn(final Iterable<T> list, final String msg, final Log log) {
    boolean _defined = OptExtensions.<Object>defined(msg);
    if (_defined) {
      log.logger.warn(msg);
    }
    final Consumer<T> _function = new Consumer<T>() {
      @Override
      public void accept(final T it) {
        Logger _logger = log.getLogger();
        String _logEntry = LogExtensions.getLogEntry(it);
        _logger.warn(_logEntry);
      }
    };
    list.forEach(_function);
  }
  
  public static <T extends Object> void error(final Iterable<T> list, final String msg, final Log log) {
    boolean _defined = OptExtensions.<Object>defined(msg);
    if (_defined) {
      log.logger.error(msg);
    }
    final Consumer<T> _function = new Consumer<T>() {
      @Override
      public void accept(final T it) {
        Logger _logger = log.getLogger();
        String _logEntry = LogExtensions.getLogEntry(it);
        _logger.error(_logEntry);
      }
    };
    list.forEach(_function);
  }
  
  protected static String getLogEntry(final Object o) {
    String _string = o.toString();
    return (" - " + _string);
  }
  
  public static <T extends Object> void printEach(final Iterable<T> list) {
    LogExtensions.<T>printEach(list, null);
  }
  
  public static <T extends Object> void trace(final Iterable<T> list, final Log log) {
    LogExtensions.<T>trace(list, null, log);
  }
  
  public static <T extends Object> void debug(final Iterable<T> list, final Log log) {
    LogExtensions.<T>debug(list, null, log);
  }
  
  public static <T extends Object> void info(final Iterable<T> list, final Log log) {
    LogExtensions.<T>info(list, null, log);
  }
  
  public static <T extends Object> void warn(final Iterable<T> list, final Log log) {
    LogExtensions.<T>warn(list, null, log);
  }
  
  public static <T extends Object> void error(final Iterable<T> list, final Log log) {
    LogExtensions.<T>error(list, null, log);
  }
}
