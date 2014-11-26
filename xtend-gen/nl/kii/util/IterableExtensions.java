package nl.kii.util;

import nl.kii.util.Opt;

@SuppressWarnings("all")
public class IterableExtensions {
  public static <T extends java.lang.Object> /* List<T> */Object list(final /* Class<T> */Object cls) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field newImmutableList is undefined for the type IterableExtensions");
  }
  
  public static <T extends java.lang.Object> /* List<T> */Object list(final T... objects) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method newImmutableList is undefined for the type IterableExtensions");
  }
  
  /**
   * Returns if a list is of a certain value type by looking at the first value.
   * @returns true if the list is not empty and the type matches
   * <pre>
   * #[1, 2, 3].isListOf(Integer) // true
   * #[1, 2, 3].isListOf(String) // false
   * #[].isListOf(Integer) // false
   */
  public static boolean isListOf(final /* List<? extends  */Object list, final /* Class<? extends  */Object type) {
    throw new Error("Unresolved compilation problems:"
      + "\nempty cannot be resolved"
      + "\nget cannot be resolved"
      + "\nclass cannot be resolved"
      + "\nisAssignableFrom cannot be resolved");
  }
  
  /**
   * Returns if a map is of a certain key and value type by looking at the first value.
   * @returns true if the map is not empty and the types match
   * <pre>
   * #{1->'A', 5->'C'}.isMapOf(Integer, String) // true
   * #{1->'A', 5->'C'}.isMapOf(Integer, Integer) // false
   * #{}.isMapOf(Integer, String) // false
   */
  public static boolean isMapOf(final /* Map<? extends  */Object map, final /* Class<? extends  */Object keyType, final /* Class<? extends  */Object valueType) {
    throw new Error("Unresolved compilation problems:"
      + "\nempty cannot be resolved"
      + "\nkeySet cannot be resolved"
      + "\nget cannot be resolved"
      + "\nclass cannot be resolved"
      + "\nisAssignableFrom cannot be resolved"
      + "\n&& cannot be resolved"
      + "\nget cannot be resolved"
      + "\nclass cannot be resolved"
      + "\nisAssignableFrom cannot be resolved");
  }
  
  /**
   * Always returns an immutable list, even if a null result is passed. handy when chaining, eliminates null checks
   * <pre>example: getUsers.filter[age>20].list</pre>
   */
  public static <T extends java.lang.Object> /* List<T> */Object toList(final /* Iterable<T> */Object iterable) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field newImmutableList is undefined for the type IterableExtensions"
      + "\ndefined cannot be resolved"
      + "\n! cannot be resolved"
      + "\niterator cannot be resolved"
      + "\ntoList cannot be resolved"
      + "\nimmutableCopy cannot be resolved");
  }
  
  /**
   * Always returns an immutable set, even if a null result was passed. handy when chaining, eliminates null checks.
   * note: double values will be removed!
   */
  public static <T extends java.lang.Object> /* Set<T> */Object toSet(final /* Iterable<? extends T> */Object iterable) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field newHashSet is undefined for the type IterableExtensions"
      + "\nHashSet cannot be resolved."
      + "\ndefined cannot be resolved"
      + "\n! cannot be resolved"
      + "\ndistinct cannot be resolved"
      + "\ntoList cannot be resolved"
      + "\nimmutableCopy cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object concat(final /* Iterable<? extends T> */Object list, final T value) {
    throw new Error("Unresolved compilation problems:"
      + "\n!= cannot be resolved."
      + "\nThe method or field ImmutableList is undefined for the type IterableExtensions"
      + "\nbuilder cannot be resolved"
      + "\naddAll cannot be resolved"
      + "\nadd cannot be resolved"
      + "\nbuild cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object concat(final T value, final /* Iterable<T> */Object list) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field ImmutableList is undefined for the type IterableExtensions"
      + "\n!= cannot be resolved"
      + "\nbuilder cannot be resolved"
      + "\nadd cannot be resolved"
      + "\naddAll cannot be resolved"
      + "\nbuild cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object concat(final /* Set<T> */Object set, final T value) {
    throw new Error("Unresolved compilation problems:"
      + "\n!= cannot be resolved."
      + "\nThe method or field ImmutableSet is undefined for the type IterableExtensions"
      + "\nbuilder cannot be resolved"
      + "\naddAll cannot be resolved"
      + "\nadd cannot be resolved"
      + "\nbuild cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object concat(final T value, final /* Set<T> */Object set) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field ImmutableSet is undefined for the type IterableExtensions"
      + "\n!= cannot be resolved"
      + "\nbuilder cannot be resolved"
      + "\nadd cannot be resolved"
      + "\naddAll cannot be resolved"
      + "\nbuild cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object uncat(final /* List<? extends T> */Object list, final T value) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field ImmutableList is undefined for the type IterableExtensions"
      + "\nbuilder cannot be resolved"
      + "\naddAll cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\n!= cannot be resolved"
      + "\nbuild cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object uncat(final /* List<? extends T> */Object list, final /* List<? extends T> */Object list2) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field ImmutableList is undefined for the type IterableExtensions"
      + "\nbuilder cannot be resolved"
      + "\naddAll cannot be resolved"
      + "\nfilter cannot be resolved"
      + "\ncontains cannot be resolved"
      + "\n! cannot be resolved"
      + "\nbuild cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Iterable effect(final /* Iterable<? extends T> */Object iterable, final /*  */Object fn) {
    throw new Error("Unresolved compilation problems:"
      + "\nforEach cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Iterable effect(final /* Iterable<? extends T> */Object iterable, final /*  */Object fn) {
    throw new Error("Unresolved compilation problems:"
      + "\nforEach cannot be resolved");
  }
  
  /**
   * Triggers the passed or function for each none in the list,
   * handy for tracking empty results, for example:
   * <pre>usersIds.map [ get user ].onNone [ println('could not find user') ].filterNone</pre>
   */
  public static <T extends java.lang.Object> /* Iterable<? extends Opt<T>> */Object onNone(final /* Iterable<? extends Opt<T>> */Object iterable, final /*  */Object noneHandler) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field hasNone is undefined for the type IterableExtensions"
      + "\nfilter cannot be resolved"
      + "\neffect cannot be resolved"
      + "\napply cannot be resolved");
  }
  
  /**
   * Triggers the passed or function for each error in the list,
   * handy for tracking errors for example:
   * <pre>usersIds.attemptMap [ get user ].onError [ error handling ].filterEmpty</pre>
   */
  public static <T extends java.lang.Object> /* Iterable<? extends Opt<T>> */Object onError(final /* Iterable<? extends Opt<T>> */Object iterable, final /*  */Object errorHandler) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field hasError is undefined for the type IterableExtensions"
      + "\nfilter cannot be resolved"
      + "\neffect cannot be resolved"
      + "\napply cannot be resolved");
  }
  
  public static <T extends java.lang.Object> T last(final /* Iterable<? extends T> */Object values) {
    throw new Error("Unresolved compilation problems:"
      + "\ntoList cannot be resolved"
      + "\nreverse cannot be resolved"
      + "\nhead cannot be resolved");
  }
  
  /**
   * Convert a list of options into actual values, filtering out the none and error values.
   * Like filterNull, but then for a list of Options
   */
  public static <T extends java.lang.Object> /* Iterable<T> */Object filterEmpty(final /* Iterable<? extends Opt<T>> */Object iterable) {
    throw new Error("Unresolved compilation problems:"
      + "\nCannot make an implicit reference to this from a static context"
      + "\nmap cannot be resolved"
      + "\nfilterNull cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object filterError(final /* Iterable<? extends Opt<T>> */Object iterable) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field hasError is undefined for the type IterableExtensions"
      + "\nfilter cannot be resolved"
      + "\n! cannot be resolved");
  }
  
  /**
   * Remove all double values in a list, turning it into a list of unique values
   */
  public static <T extends java.lang.Object> Object distinct(final /* Iterable<? extends T> */Object values) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field value is undefined for the type IterableExtensions"
      + "\ngroupBy cannot be resolved"
      + "\ntoPairs cannot be resolved"
      + "\nmap cannot be resolved"
      + "\nhead cannot be resolved");
  }
  
  /**
   * Returns the position/index of the value in the iterable, starting at 0
   */
  public static <T extends java.lang.Object> int indexOf(final /* Iterable<? extends T> */Object iterable, final T value) {
    throw new Error("Unresolved compilation problems:"
      + "\n+ cannot be resolved."
      + "\n- cannot be resolved."
      + "\nequals cannot be resolved");
  }
  
  /**
   * map all the some's, leaving alone the none's
   */
  public static <T extends java.lang.Object, R extends java.lang.Object> /* Iterable<Opt<R>> */Object mapOpt(final /* Iterable<? extends Opt<T>> */Object iterable, final /*  */Object fn) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe static method map(List, Object) should be accessed in a static way"
      + "\nmap cannot be resolved");
  }
  
  /**
   * try to map the values in the iterable, and give back a list of options instead of direct values
   */
  public static <T extends java.lang.Object, R extends java.lang.Object> Object attemptMap(final /* Iterable<? extends T> */Object iterable, final /*  */Object fn) {
    throw new Error("Unresolved compilation problems:"
      + "\nmap cannot be resolved"
      + "\napply cannot be resolved");
  }
  
  /**
   * transforms a map into a list of pairs
   */
  public static <K extends java.lang.Object, V extends java.lang.Object> Object toPairs(final /* Map<K, V> */Object map) {
    throw new Error("Unresolved compilation problems:"
      + "\nentrySet cannot be resolved"
      + "\nmap cannot be resolved"
      + "\nkey cannot be resolved"
      + "\n-> cannot be resolved"
      + "\nvalue cannot be resolved"
      + "\ntoList cannot be resolved");
  }
  
  /**
   * Convert a list of pairs to a map
   */
  public static <K extends java.lang.Object, V extends java.lang.Object> /* Map<K, V> */Object toMap(final /* Iterable<Pair<K, V>> */Object pairs) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field newHashMap is undefined for the type IterableExtensions"
      + "\nThe method or field key is undefined for the type IterableExtensions"
      + "\nThe method or field value is undefined for the type IterableExtensions"
      + "\ndefined cannot be resolved"
      + "\nforEach cannot be resolved"
      + "\nput cannot be resolved");
  }
  
  /**
   * Create a grouped index for a list of items. if the keys are unique, use toMap instead!
   * <p>
   * Example: val groups = levels.groupBy [ difficulty ] // creates a map with per difficulty level a list of levels
   */
  public static <K extends java.lang.Object, V extends java.lang.Object> /* Map<K, List<V>> */Object groupBy(final /* Iterable<? extends V> */Object list, final /*  */Object indexFn) {
    throw new Error("Unresolved compilation problems:"
      + "\nHashMap cannot be resolved."
      + "\nThe method newLinkedList is undefined for the type IterableExtensions"
      + "\nList cannot be resolved to a type."
      + "\nforEach cannot be resolved"
      + "\napply cannot be resolved"
      + "\ncontainsKey cannot be resolved"
      + "\nget cannot be resolved"
      + "\nadd cannot be resolved"
      + "\nput cannot be resolved");
  }
  
  /**
   * Lets you map a pair using
   */
  public static <K extends java.lang.Object, V extends java.lang.Object, R extends java.lang.Object> Object map(final /* List<Pair<K, V>> */Object list, final /*  */Object mapFn) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field key is undefined for the type IterableExtensions"
      + "\nThe method or field value is undefined for the type IterableExtensions"
      + "\nmap cannot be resolved"
      + "\napply cannot be resolved");
  }
  
  /**
   * Convert to a different type. will throw a class cast exception at runtime
   * if you convert to the wrong type!
   */
  public static <T extends java.lang.Object> /* Iterable<T> */Object mapAs(final /* Iterable<? extends  */Object iterable, final /* Class<T> */Object type) {
    throw new Error("Unresolved compilation problems:"
      + "\nmap cannot be resolved");
  }
  
  /**
   * Flatten a list of keys -> list of pair values into more key->value pairs
   */
  public static <K extends java.lang.Object, V extends java.lang.Object> /* Iterable<Pair<K, V>> */Object flattenValues(final /* Iterable<Pair<K, List<V>>> */Object pairs) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field newLinkedList is undefined for the type IterableExtensions"
      + "\nforEach cannot be resolved"
      + "\nvalue cannot be resolved"
      + "\nforEach cannot be resolved"
      + "\nadd cannot be resolved"
      + "\nkey cannot be resolved"
      + "\n-> cannot be resolved");
  }
  
  public static <V extends java.lang.Object> /* Map<V, Integer> */Object count(final /* Iterable<? extends V> */Object values) {
    throw new Error("Unresolved compilation problems:"
      + "\ncountBy cannot be resolved");
  }
  
  public static <K extends java.lang.Object, V extends java.lang.Object> /* Map<V, Integer> */Object countBy(final /* Iterable<? extends V> */Object values, final /*  */Object indexFn) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method or field value is undefined for the type IterableExtensions"
      + "\nThe method or field value is undefined for the type IterableExtensions"
      + "\ngroupBy cannot be resolved"
      + "\ntoPairs cannot be resolved"
      + "\nmap cannot be resolved"
      + "\nhead cannot be resolved"
      + "\n-> cannot be resolved"
      + "\nsize cannot be resolved"
      + "\ntoMap cannot be resolved");
  }
  
  public static <K extends java.lang.Object, V extends java.lang.Object> /* Map<K, V> */Object index(final /* Iterable<? extends V> */Object iterable, final /*  */Object indexFn) {
    throw new Error("Unresolved compilation problems:"
      + "\ntoMap cannot be resolved"
      + "\napply cannot be resolved");
  }
  
  public static <T/*  extends Number */> double sum(final /* Iterable<? extends T> */Object values) {
    throw new Error("Unresolved compilation problems:"
      + "\n+ cannot be resolved."
      + "\nThe method doubleValue is undefined for the type IterableExtensions");
  }
  
  public static <T/*  extends Number */> Object average(final /* Iterable<? extends T> */Object values) {
    throw new Error("Unresolved compilation problems:"
      + "\nsum cannot be resolved"
      + "\n/ cannot be resolved"
      + "\nlength cannot be resolved");
  }
  
  public static <T extends java.lang.Object> boolean in(final T instance, final T... objects) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method defined is undefined for the type IterableExtensions"
      + "\nThe method defined is undefined for the type IterableExtensions"
      + "\nThe method contains is undefined for the type IterableExtensions"
      + "\n&& cannot be resolved"
      + "\n&& cannot be resolved");
  }
  
  public static <T extends java.lang.Object> boolean in(final T instance, final /* Iterable<? extends T> */Object objects) {
    throw new Error("Unresolved compilation problems:"
      + "\ntoList cannot be resolved"
      + "\ncontains cannot be resolved");
  }
  
  public static <T extends java.lang.Object> boolean in(final T instance, final /* Iterator<? extends T> */Object objects) {
    throw new Error("Unresolved compilation problems:"
      + "\nThe method defined is undefined for the type IterableExtensions"
      + "\n&& cannot be resolved"
      + "\ndefined cannot be resolved"
      + "\n&& cannot be resolved"
      + "\ntoList cannot be resolved"
      + "\ncontains cannot be resolved");
  }
  
  /**
   * Create a new immutable list from this list that does not contain the value
   */
  public static <T extends java.lang.Object> Object operator_minus(final /* List<? extends T> */Object list, final T value) {
    throw new Error("Unresolved compilation problems:"
      + "\nuncat cannot be resolved");
  }
  
  /**
   * Create a new immutable list from a list and a value
   */
  public static <T extends java.lang.Object> Object operator_plus(final /* Iterable<? extends T> */Object list, final T value) {
    throw new Error("Unresolved compilation problems:"
      + "\nconcat cannot be resolved");
  }
  
  /**
   * Create a new immutable list from this list that does not contain the value
   */
  public static <T extends java.lang.Object> Object operator_minus(final /* List<? extends T> */Object list, final /* List<? extends T> */Object list2) {
    throw new Error("Unresolved compilation problems:"
      + "\nuncat cannot be resolved");
  }
  
  /**
   * Create a new immutable list from a value and a list
   */
  public static <T extends java.lang.Object, R extends java.lang.Object> Object operator_mappedTo(final /* Iterable<? extends T> */Object original, final /* Functions.Function1<? super T, ? extends R> */Object transformation) {
    throw new Error("Unresolved compilation problems:"
      + "\nmap cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object operator_plus(final /* Iterable<? extends T> */Object unfiltered, final /* Functions.Function1<? super T, Boolean> */Object predicate) {
    throw new Error("Unresolved compilation problems:"
      + "\nfilter cannot be resolved");
  }
  
  public static <T extends java.lang.Object> Object operator_minus(final /* Iterable<? extends T> */Object unfiltered, final /* Functions.Function1<? super T, Boolean> */Object predicate) {
    throw new Error("Unresolved compilation problems:"
      + "\nfilter cannot be resolved"
      + "\napply cannot be resolved"
      + "\n! cannot be resolved");
  }
  
  public static <T extends java.lang.Object> /* Functions.Function1<? super T, Boolean> */Object operator_not(final /* Functions.Function1<? super T, Boolean> */Object predicate) {
    throw new Error("Unresolved compilation problems:"
      + "\napply cannot be resolved"
      + "\n! cannot be resolved");
  }
}
