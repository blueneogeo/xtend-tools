package nl.kii.util;

import java.io.Closeable;
import java.io.IOException;
import org.eclipse.xtext.xbase.lib.Exceptions;

@SuppressWarnings("all")
public class Readable implements Closeable {
  public boolean isClosed = true;
  
  public boolean open() {
    return this.isClosed = false;
  }
  
  public String hello() {
    try {
      String _xblockexpression = null;
      {
        if (this.isClosed) {
          throw new Exception("cannot hello when closed");
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
