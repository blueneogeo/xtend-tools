package nl.kii.util;

@SuppressWarnings("all")
public class Readable /* implements Closeable  */{
  public boolean isClosed = true;
  
  public boolean open() {
    return this.isClosed = false;
  }
  
  public java.lang.String hello() {
    throw new Error("Unresolved compilation problems:"
      + "\nException cannot be resolved.");
  }
  
  public boolean close()/*  throws IOException */ {
    return this.isClosed = true;
  }
}
