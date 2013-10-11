package nl.kii.util;

import java.io.Closeable;
import java.io.IOException;
import org.eclipse.xtext.xbase.lib.Exceptions;

@SuppressWarnings("all")
public class Readable implements Closeable {
  public boolean isClosed = true;
  
  public boolean open() {
    boolean _isClosed = this.isClosed = false;
    return _isClosed;
  }
  
  public String hello() {
    try {
      String _xblockexpression = null;
      {
        if (this.isClosed) {
          Exception _exception = new Exception("cannot hello when closed");
          throw _exception;
        }
        _xblockexpression = ("hello, I am open!");
      }
      return _xblockexpression;
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  public void close() throws IOException {
    this.isClosed = true;
  }
}
