package nl.kii.util;

import java.util.Iterator;
import java.util.LinkedList;
import nl.kii.util.NoneException;
import nl.kii.util.Opt;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Exceptions;

@SuppressWarnings("all")
public class Err<T extends Object> extends Opt<T> {
  private final Throwable exception;
  
  public Err() {
    try {
      Exception _exception = new Exception();
      throw _exception;
    } catch (final Throwable _t) {
      if (_t instanceof Exception) {
        final Exception e = (Exception)_t;
        this.exception = e;
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
  }
  
  public Err(final Throwable exception) {
    this.exception = exception;
  }
  
  public Throwable getException() {
    return this.exception;
  }
  
  public String getMessage() {
    String _message = this.exception.getMessage();
    return _message;
  }
  
  public StackTraceElement[] getStackTrace() {
    StackTraceElement[] _stackTrace = this.exception.getStackTrace();
    return _stackTrace;
  }
  
  public T value() {
    try {
      NoneException _noneException = new NoneException();
      throw _noneException;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public boolean hasSome() {
    return false;
  }
  
  public boolean hasNone() {
    return false;
  }
  
  public boolean hasError() {
    return true;
  }
  
  public Iterator<T> iterator() {
    LinkedList<T> _newLinkedList = CollectionLiterals.<T>newLinkedList();
    Iterator<T> _iterator = _newLinkedList.iterator();
    return _iterator;
  }
  
  public boolean equals(final Object obj) {
    return (obj instanceof Err<?>);
  }
  
  public int hashCode() {
    int _minus = (-1);
    return _minus;
  }
  
  public String toString() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("Error (");
    String _message = this.exception.getMessage();
    _builder.append(_message, "");
    _builder.append(")");
    return _builder.toString();
  }
}
