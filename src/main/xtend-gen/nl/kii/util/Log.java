package nl.kii.util;

import com.google.common.base.Objects;
import org.eclipse.xtend.lib.annotations.Data;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.eclipse.xtext.xbase.lib.Pure;
import org.eclipse.xtext.xbase.lib.util.ToStringBuilder;
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
  protected final Logger logger;
  
  protected final String name;
  
  public void trace(final Function1<? super Object, ? extends String> message) {
    boolean _isTraceEnabled = this.logger.isTraceEnabled();
    if (_isTraceEnabled) {
      String _entry = this.getEntry(message);
      this.logger.trace(_entry);
    }
  }
  
  public void debug(final Function1<? super Object, ? extends String> message) {
    boolean _isDebugEnabled = this.logger.isDebugEnabled();
    if (_isDebugEnabled) {
      String _entry = this.getEntry(message);
      this.logger.debug(_entry);
    }
  }
  
  public void info(final String message) {
    boolean _isInfoEnabled = this.logger.isInfoEnabled();
    if (_isInfoEnabled) {
      String _entry = this.getEntry(message);
      this.logger.info(_entry);
    }
  }
  
  public void info(final Function1<? super Object, ? extends String> message) {
    boolean _isInfoEnabled = this.logger.isInfoEnabled();
    if (_isInfoEnabled) {
      String _entry = this.getEntry(message);
      this.logger.info(_entry);
    }
  }
  
  public void warn(final String message) {
    boolean _isWarnEnabled = this.logger.isWarnEnabled();
    if (_isWarnEnabled) {
      String _entry = this.getEntry(message);
      this.logger.warn(_entry);
    }
  }
  
  public void warn(final Function1<? super Object, ? extends String> message) {
    boolean _isWarnEnabled = this.logger.isWarnEnabled();
    if (_isWarnEnabled) {
      String _entry = this.getEntry(message);
      this.logger.warn(_entry);
    }
  }
  
  public void error(final String message, final Throwable t) {
    boolean _isErrorEnabled = this.logger.isErrorEnabled();
    if (_isErrorEnabled) {
      final Function1<Object, String> _function = new Function1<Object, String>() {
        public String apply(final Object it) {
          return message;
        }
      };
      String _entry = this.getEntry(_function);
      this.logger.error(_entry, t);
    }
  }
  
  public <T extends Object> Procedure1<? super T> trace() {
    final Procedure1<T> _function = new Procedure1<T>() {
      public void apply(final T it) {
        String _string = it.toString();
        Log.this.logger.trace(_string);
      }
    };
    return _function;
  }
  
  public <T extends Object> Procedure1<? super T> debug() {
    final Procedure1<T> _function = new Procedure1<T>() {
      public void apply(final T it) {
        String _string = it.toString();
        Log.this.logger.debug(_string);
      }
    };
    return _function;
  }
  
  public <T extends Object> Procedure1<? super T> info() {
    final Procedure1<T> _function = new Procedure1<T>() {
      public void apply(final T it) {
        String _string = it.toString();
        Log.this.logger.info(_string);
      }
    };
    return _function;
  }
  
  public <T extends Object> Procedure1<? super T> warn() {
    final Procedure1<T> _function = new Procedure1<T>() {
      public void apply(final T it) {
        String _string = it.toString();
        Log.this.logger.warn(_string);
      }
    };
    return _function;
  }
  
  public <T extends Object> Procedure1<? super T> error() {
    final Procedure1<T> _function = new Procedure1<T>() {
      public void apply(final T it) {
        String _string = it.toString();
        Log.this.logger.error(_string);
      }
    };
    return _function;
  }
  
  protected String getEntry(final String message) {
    String _xifexpression = null;
    boolean _notEquals = (!Objects.equal(this.name, null));
    if (_notEquals) {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append(this.name, "");
      _builder.append(": ");
      _builder.append(message, "");
      _xifexpression = _builder.toString();
    } else {
      _xifexpression = message;
    }
    return _xifexpression;
  }
  
  protected String getEntry(final Function1<? super Object, ? extends String> message) {
    String _apply = message.apply(null);
    return this.getEntry(_apply);
  }
  
  public Log(final Logger logger, final String name) {
    super();
    this.logger = logger;
    this.name = name;
  }
  
  @Override
  @Pure
  public int hashCode() {
    final int prime = 31;
    int result = 1;
    result = prime * result + ((this.logger== null) ? 0 : this.logger.hashCode());
    result = prime * result + ((this.name== null) ? 0 : this.name.hashCode());
    return result;
  }
  
  @Override
  @Pure
  public boolean equals(final Object obj) {
    if (this == obj)
      return true;
    if (obj == null)
      return false;
    if (getClass() != obj.getClass())
      return false;
    Log other = (Log) obj;
    if (this.logger == null) {
      if (other.logger != null)
        return false;
    } else if (!this.logger.equals(other.logger))
      return false;
    if (this.name == null) {
      if (other.name != null)
        return false;
    } else if (!this.name.equals(other.name))
      return false;
    return true;
  }
  
  @Override
  @Pure
  public String toString() {
    ToStringBuilder b = new ToStringBuilder(this);
    b.add("logger", this.logger);
    b.add("name", this.name);
    return b.toString();
  }
  
  @Pure
  public Logger getLogger() {
    return this.logger;
  }
  
  @Pure
  public String getName() {
    return this.name;
  }
}
