package nl.kii.util;

import nl.kii.util.Log;

@SuppressWarnings("all")
public class LogExtensions {
  public static Log wrapper(final /* Logger */Object logger) {
    throw new Error("Unresolved compilation problems:"
      + "\nInvalid number of arguments. The constructor Log() is not applicable for the arguments (Logger,null)");
  }
  
  public static Log wrapper(final /* Logger */Object logger, final /* String */Object name) {
    throw new Error("Unresolved compilation problems:"
      + "\nInvalid number of arguments. The constructor Log() is not applicable for the arguments (Logger,String)");
  }
  
  public static Object print(final /* CharSequence */Object... s) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method println is undefined for the type LogExtensions"
      + "\nforEach cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object print(final /*  */Object s) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method println is undefined for the type LogExtensions"
      + "\napply cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object print(final /*  */Object o) {
    throw new Error("Unresolved compilation problems:"
      + "\napply cannot be resolved");
  }
  
  public static <T extends java.lang.Object> /*  */Object printEach() {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method println is undefined for the type LogExtensions");
  }
  
  public static <T extends java.lang.Object> /*  */Object printEach(final /* String */Object msg) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method println is undefined for the type LogExtensions"
      + "\n+ cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object printEach(final /* Iterable<T> */Object list, final /* String */Object msg) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method println is undefined for the type LogExtensions"
      + "\nThe method println is undefined for the type LogExtensions"
      + "\nInvalid number of arguments. The method getLogEntry(Object) is not applicable without arguments"
      + "\ndefined cannot be resolved"
      + "\nforEach cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object trace(final /* Iterable<T> */Object list, final /* String */Object msg, final Log log) {
    throw new Error("Unresolved compilation problems:"
      + "\nInvalid number of arguments. The method getLogEntry(Object) is not applicable without arguments"
      + "\ndefined cannot be resolved"
      + "\ntrace cannot be resolved"
      + "\nforEach cannot be resolved"
      + "\ntrace cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object debug(final /* Iterable<T> */Object list, final /* String */Object msg, final Log log) {
    throw new Error("Unresolved compilation problems:"
      + "\nInvalid number of arguments. The method getLogEntry(Object) is not applicable without arguments"
      + "\ndefined cannot be resolved"
      + "\ndebug cannot be resolved"
      + "\nforEach cannot be resolved"
      + "\ndebug cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object info(final /* Iterable<T> */Object list, final /* String */Object msg, final Log log) {
    throw new Error("Unresolved compilation problems:"
      + "\nInvalid number of arguments. The method getLogEntry(Object) is not applicable without arguments"
      + "\ndefined cannot be resolved"
      + "\ninfo cannot be resolved"
      + "\nforEach cannot be resolved"
      + "\ninfo cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object warn(final /* Iterable<T> */Object list, final /* String */Object msg, final Log log) {
    throw new Error("Unresolved compilation problems:"
      + "\nInvalid number of arguments. The method getLogEntry(Object) is not applicable without arguments"
      + "\ndefined cannot be resolved"
      + "\nwarn cannot be resolved"
      + "\nforEach cannot be resolved"
      + "\nwarn cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object error(final /* Iterable<T> */Object list, final /* String */Object msg, final Log log) {
    throw new Error("Unresolved compilation problems:"
      + "\nInvalid number of arguments. The method getLogEntry(Object) is not applicable without arguments"
      + "\ndefined cannot be resolved"
      + "\nerror cannot be resolved"
      + "\nforEach cannot be resolved"
      + "\nerror cannot be resolved");
  }
  
  protected static Object getLogEntry(final /* Object */Object o) {
    throw new Error("Unresolved compilation problems:"
      + "\n+ cannot be resolved"
      + "\ntoString cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object printEach(final /* Iterable<T> */Object list) {
    return LogExtensions.<java.lang.Object>printEach(list, null);
  }
  
  public static <T extends java.lang.Object> Object trace(final /* Iterable<T> */Object list, final Log log) {
    return LogExtensions.<java.lang.Object>trace(list, null, log);
  }
  
  public static <T extends java.lang.Object> Object debug(final /* Iterable<T> */Object list, final Log log) {
    return LogExtensions.<java.lang.Object>debug(list, null, log);
  }
  
  public static <T extends java.lang.Object> Object info(final /* Iterable<T> */Object list, final Log log) {
    return LogExtensions.<java.lang.Object>info(list, null, log);
  }
  
  public static <T extends java.lang.Object> Object warn(final /* Iterable<T> */Object list, final Log log) {
    return LogExtensions.<java.lang.Object>warn(list, null, log);
  }
  
  public static <T extends java.lang.Object> Object error(final /* Iterable<T> */Object list, final Log log) {
    return LogExtensions.<java.lang.Object>error(list, null, log);
  }
}
