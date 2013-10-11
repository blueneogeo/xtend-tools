package nl.kii.util;

import com.google.common.base.Objects;
import org.eclipse.xtend.lib.Data;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.util.ToStringHelper;
import org.slf4j.Logger;

/**
 * Better logging for Xtend. Usage:
 * <ul>
 * <li>import static extension nl.kii.tools.XtendTools.
 * <li>import static extension org.slf4j.LoggerFactory.
 * <li>Declaration: extension Log logger = class.logger.wrapper
 * <li>Usage example: info ['''bulk shown «bulkShownUsers.size» out of the requested ''']
 * </ul>
 */
@Data
@SuppressWarnings("all")
public class Log {
  private final Logger _logger;
  
  public Logger getLogger() {
    return this._logger;
  }
  
  private final String _name;
  
  public String getName() {
    return this._name;
  }
  
  public void trace(final Function1<? super Object,? extends String> message) {
    Logger _logger = this.getLogger();
    boolean _isTraceEnabled = _logger.isTraceEnabled();
    if (_isTraceEnabled) {
      Logger _logger_1 = this.getLogger();
      String _entry = this.getEntry(message);
      _logger_1.trace(_entry);
    }
  }
  
  public void debug(final Function1<? super Object,? extends String> message) {
    Logger _logger = this.getLogger();
    boolean _isDebugEnabled = _logger.isDebugEnabled();
    if (_isDebugEnabled) {
      Logger _logger_1 = this.getLogger();
      String _entry = this.getEntry(message);
      _logger_1.debug(_entry);
    }
  }
  
  public void info(final Function1<? super Object,? extends String> message) {
    Logger _logger = this.getLogger();
    boolean _isInfoEnabled = _logger.isInfoEnabled();
    if (_isInfoEnabled) {
      Logger _logger_1 = this.getLogger();
      String _entry = this.getEntry(message);
      _logger_1.info(_entry);
    }
  }
  
  public void warn(final Function1<? super Object,? extends String> message) {
    Logger _logger = this.getLogger();
    boolean _isWarnEnabled = _logger.isWarnEnabled();
    if (_isWarnEnabled) {
      Logger _logger_1 = this.getLogger();
      String _entry = this.getEntry(message);
      _logger_1.warn(_entry);
    }
  }
  
  public void error(final Function1<? super Object,? extends String> message) {
    Logger _logger = this.getLogger();
    boolean _isErrorEnabled = _logger.isErrorEnabled();
    if (_isErrorEnabled) {
      Logger _logger_1 = this.getLogger();
      String _entry = this.getEntry(message);
      _logger_1.error(_entry);
    }
  }
  
  protected String getEntry(final Function1<? super Object,? extends String> message) {
    String _xifexpression = null;
    String _name = this.getName();
    boolean _notEquals = (!Objects.equal(_name, null));
    if (_notEquals) {
      StringConcatenation _builder = new StringConcatenation();
      String _name_1 = this.getName();
      _builder.append(_name_1, "");
      _builder.append(": ");
      String _apply = message.apply(null);
      _builder.append(_apply, "");
      String _string = _builder.toString();
      _xifexpression = _string;
    } else {
      String _apply_1 = message.apply(null);
      _xifexpression = _apply_1;
    }
    return _xifexpression;
  }
  
  public Log(final Logger logger, final String name) {
    super();
    this._logger = logger;
    this._name = name;
  }
  
  @Override
  public int hashCode() {
    final int prime = 31;
    int result = 1;
    result = prime * result + ((_logger== null) ? 0 : _logger.hashCode());
    result = prime * result + ((_name== null) ? 0 : _name.hashCode());
    return result;
  }
  
  @Override
  public boolean equals(final Object obj) {
    if (this == obj)
      return true;
    if (obj == null)
      return false;
    if (getClass() != obj.getClass())
      return false;
    Log other = (Log) obj;
    if (_logger == null) {
      if (other._logger != null)
        return false;
    } else if (!_logger.equals(other._logger))
      return false;
    if (_name == null) {
      if (other._name != null)
        return false;
    } else if (!_name.equals(other._name))
      return false;
    return true;
  }
  
  @Override
  public String toString() {
    String result = new ToStringHelper().toString(this);
    return result;
  }
}
