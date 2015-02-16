package nl.kii.util;

import com.google.common.base.Objects;
import java.util.List;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.ListExtensions;

@SuppressWarnings("all")
public class ThrowableExtensions {
  public static String format(final Throwable it) {
    return ThrowableExtensions.format(it, null);
  }
  
  public static String format(final Throwable it, final String message) {
    StringConcatenation _builder = new StringConcatenation();
    {
      boolean _notEquals = (!Objects.equal(message, null));
      if (_notEquals) {
        _builder.append("Thrown: ");
        _builder.append(message, "");
      }
    }
    _builder.newLineIfNotEmpty();
    _builder.append("Thrown ");
    Class<? extends Throwable> _class = it.getClass();
    String _simpleName = _class.getSimpleName();
    _builder.append(_simpleName, "");
    _builder.append(" - ");
    _builder.append(message, "");
    _builder.append(":");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    String _message = it.getMessage();
    _builder.append(_message, "\t");
    _builder.newLineIfNotEmpty();
    {
      StackTraceElement[] _stackTrace = it.getStackTrace();
      final Function1<StackTraceElement, String> _function = new Function1<StackTraceElement, String>() {
        public String apply(final StackTraceElement it) {
          return it.toString();
        }
      };
      List<String> _map = ListExtensions.<StackTraceElement, String>map(((List<StackTraceElement>)Conversions.doWrapArray(_stackTrace)), _function);
      for(final String trace : _map) {
        _builder.append("\t");
        _builder.append("- ");
        _builder.append(trace, "\t");
        _builder.newLineIfNotEmpty();
      }
    }
    {
      Throwable _cause = it.getCause();
      boolean _notEquals_1 = (!Objects.equal(_cause, null));
      if (_notEquals_1) {
        _builder.append("Caused by ");
        Throwable _cause_1 = it.getCause();
        Class<? extends Throwable> _class_1 = _cause_1.getClass();
        String _simpleName_1 = _class_1.getSimpleName();
        _builder.append(_simpleName_1, "");
        _builder.append(":");
        _builder.newLineIfNotEmpty();
        _builder.append("\t");
        Throwable _cause_2 = it.getCause();
        String _message_1 = _cause_2.getMessage();
        _builder.append(_message_1, "\t");
        _builder.newLineIfNotEmpty();
        {
          Throwable _cause_3 = it.getCause();
          StackTraceElement[] _stackTrace_1 = _cause_3.getStackTrace();
          final Function1<StackTraceElement, String> _function_1 = new Function1<StackTraceElement, String>() {
            public String apply(final StackTraceElement it) {
              return it.toString();
            }
          };
          List<String> _map_1 = ListExtensions.<StackTraceElement, String>map(((List<StackTraceElement>)Conversions.doWrapArray(_stackTrace_1)), _function_1);
          for(final String trace_1 : _map_1) {
            _builder.append("\t");
            _builder.append("- ");
            _builder.append(trace_1, "\t");
            _builder.newLineIfNotEmpty();
          }
        }
      }
    }
    return _builder.toString();
  }
}
