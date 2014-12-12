package nl.kii.util;

import nl.kii.util.Opt;

@SuppressWarnings("all")
public class CloseableExtensions {
  /**
   * Perform an operation on a closable, and close it when finished
   */
  public static <I/*  extends Closeable */> Object using(final I closable, final /*  */Object fn) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method close is undefined for the type CloseableExtensions"
      + "\napply cannot be resolved");
  }
  
  /**
   * Perform an operation on a closable, and close it when finished
   */
  public static <I/*  extends Closeable */, T extends java.lang.Object> Object using(final I closable, final /*  */Object fn) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method close is undefined for the type CloseableExtensions"
      + "\napply cannot be resolved");
  }
  
  public static <I/*  extends Closeable */, T extends java.lang.Object> Opt<T> attemptUsing(final I closable, final /*  */Object fn) {
    throw new Error("Unresolved compilation problems:"
      + "\nThrowable cannot be resolved to a type."
      + "\nNo exception of type Throwable can be thrown; an exception type must be a subclass of Throwable"
      + "\noption cannot be resolved");
  }
}
