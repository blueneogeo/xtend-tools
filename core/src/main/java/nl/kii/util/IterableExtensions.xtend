package nl.kii.util

import com.google.common.collect.ImmutableList
import com.google.common.collect.ImmutableSet
import java.util.HashMap
import java.util.HashSet
import java.util.Iterator
import java.util.List
import java.util.Map
import java.util.NoSuchElementException
import java.util.Random
import java.util.Set

import static extension nl.kii.util.OptExtensions.*

class IterableExtensions {

	// CREATING (immutable) ///////////////////////////////////////////////////
	
	def static <T> List<T> list(Class<T> cls) {
		newImmutableList
	}

	def static <T> List<T> list(T... objects) {
		newImmutableList(objects)
	}

	// REFLECTION /////////////////////////////////////////////////////////////
	
	/** 
	 * Returns if a list is of a certain value type by looking at the first value. 
	 * @returns true if the list is not empty and the type matches
	 * <pre>
	 * #[1, 2, 3].isListOf(Integer) // true
	 * #[1, 2, 3].isListOf(String) // false
	 * #[].isListOf(Integer) // false
	 */
	def static boolean isListOf(List<?> list, Class<?> type) {
		if(list.empty) return false
		list.get(0).class.isAssignableFrom(type)
	}

	/** 
	 * Returns if a map is of a certain key and value type by looking at the first value. 
	 * @returns true if the map is not empty and the types match
	 * <pre>
	 * #{1->'A', 5->'C'}.isMapOf(Integer, String) // true
	 * #{1->'A', 5->'C'}.isMapOf(Integer, Integer) // false
	 * #{}.isMapOf(Integer, String) // false
	 */
	def static boolean isMapOf(Map<?, ?> map, Class<?> keyType, Class<?> valueType) {
		if(map.empty) return false
		val key0 = map.keySet.get(0)
		key0.class.isAssignableFrom(keyType) && map.get(key0).class.isAssignableFrom(valueType)
	}

	// CONVERTING (immutable) /////////////////////////////////////////////////
	
	/** Always returns an immutable list, even if a null result is passed. handy when chaining, eliminates null checks
	 * <pre>example: getUsers.filter[age>20].list</pre>
	 */
	def static <T> List<T> toList(Iterable<? extends T> iterable) {
		if(!iterable.defined) newImmutableList else iterable.iterator.toList.immutableCopy
	}

	/** Always returns an immutable set, even if a null result was passed. handy when chaining, eliminates null checks.	
	 * note: double values will be removed!
	 */
	def static <T> Set<T> toSet(Iterable<? extends T> iterable) {
		if (!iterable.defined)
			newHashSet
		else {
			val uniques = iterable.distinct.toList
			new HashSet<T>(uniques).immutableCopy
		}
	}

	// ADDING (immutable) /////////////////////////////////////////////////////
	
	def static <T> concat(Iterable<? extends T> list, Iterable<? extends T> values) {
		if(values != null) ImmutableList.builder.addAll(list).addAll(values).build
		else throw new NullPointerException('concat: passed values are null')
	}

	def static <T> concat(T value, Iterable<T> list) {
		if(list != null) ImmutableList.builder.add(value).addAll(list).build
		else throw new NullPointerException('concat: passed list is null')
	}

	def static <T> concat(Iterable<? extends T> list, T value) {
		if(value != null) ImmutableList.builder.addAll(list).add(value).build
		else throw new NullPointerException('concat: passed value is null')
	}

	def static <T> concat(Set<T> set, T value) {
		if(value != null) ImmutableSet.builder.addAll(set).add(value).build
		else throw new NullPointerException('concat: passed value is null')
	}

	def static <T> concat(T value, Set<T> set) {
		if(set != null) ImmutableSet.builder.add(value).addAll(set).build
		else throw new NullPointerException('concat: passed set is null')
	}
	
	// REMOVING (immutable) ///////////////////////////////////////////////////
	
	def static <T> uncat(List<? extends T> list, T value) {
		val filtered = list.filter[it != value]
		ImmutableList.builder.addAll(filtered).build
	}

	def static <T> uncat(List<? extends T> list, List<? extends T> list2) {
		val filtered = list.filter[!list2.contains(it)]
		ImmutableList.builder.addAll(filtered).build
	}

	// SIDEEFFECTS ////////////////////////////////////////////////////////////
	
	def static <T> effect(Iterable<? extends T> iterable, (T)=>void fn) {
		iterable.forEach(fn)
		iterable
	}

	def static <T> effect(Iterable<? extends T> iterable, (T, int)=>void fn) {
		iterable.forEach(fn)
		iterable
	}

	/** Triggers the passed or function for each none in the list,
	 * handy for tracking empty results, for example:
	 * <pre>usersIds.map [ get user ].onNone [ println('could not find user') ].filterNone</pre>
	 */
	def static <T> Iterable<? extends Opt<T>> onNone(Iterable<? extends Opt<T>> iterable, (None<T>)=>void noneHandler) {
		iterable.filter[hasNone].effect[noneHandler.apply(it as None<T>)]
		iterable
	}

	/** Triggers the passed or function for each error in the list,
	 * handy for tracking errors for example:
	 * <pre>usersIds.attemptMap [ get user ].onError [ error handling ].filterEmpty</pre>
	 */
	def static <T> Iterable<? extends Opt<T>> onError(Iterable<? extends Opt<T>> iterable, (Err<T>)=>void errorHandler) {
		iterable.filter[hasError].effect[errorHandler.apply(it as Err<T>)]
		iterable
	}

	// FILTERING //////////////////////////////////////////////////////////////
	
	def static <T> T last(Iterable<? extends T> values) {
		values.toList.reverse.head
	}

	def static <T> Iterable<? extends T> last(Iterable<? extends T> iterable, int amount) {
		if (iterable.size <= amount) iterable
		else iterable.tail.last(amount)
	}

	/** Returns a random entry of the {@code Iterable} it is performed on. In case of an empty list, {@code null} is returned.  */
	def static <T> T random(Iterable<? extends T> values) {
		if (values.size == 0) return null
		val rand = new Random().nextInt(values.size)
		values.toList.get(rand)
	}

	/** Convert a list of options into actual values, filtering out the none and error values.
		Like filterNull, but then for a list of Options */
	def static <T> Iterable<T> filterEmpty(Iterable<? extends Opt<T>> iterable) {
		iterable.map[orNull].filterNull
	}

	def static <T> filterError(Iterable<? extends Opt<T>> iterable) {
		iterable.filter[!hasError]
	}
	
	/** Remove all double values in a list, turning it into a list of unique values */
	def static <T> distinct(Iterable<? extends T> values) {
		values.distinctBy[it]
	}

	/** Returns a filtered list of unique values, distinguished by {@code distinction}, first-come first-served. */
	def static <T, D> distinctBy(Iterable<? extends T> values, (T)=>D distinction) {
		values.groupBy(distinction).toPairs.map[value.head]
	}

	/** Returns the position/index of the value in the iterable, starting at 0 */
	def static <T> int indexOf(Iterable<? extends T> iterable, T value) {
		var counter = 0
		for (o : iterable) {
			if(o.equals(value)) return counter
			counter = counter + 1
		}
		return -1
	}

	// MAPPING ////////////////////////////////////////////////////////////////
	
	/** map all the some's, leaving alone the none's */
	def static <T, R> Iterable<Opt<R>> mapOpt(Iterable<? extends Opt<T>> iterable, (T)=>R fn) {
		iterable.map[map(fn)]
	}

	/** try to map the values in the iterable, and give back a list of options instead of direct values */
	def static <T, R> attemptMap(Iterable<? extends T> iterable, (T)=>R fn) {
		iterable.map [
			val o = it
			attempt [fn.apply(o)]
		]
	}

	/** Turns a flat iterable into iterable groups of size {@code groupSize}. 
	 * 	Note: last entry size might be smaller than the specified {@code groupSize}.
	 * @throws IllegalArgumentException if groupSize < 1
	 */
	def static <T> unflatten(Iterable<? extends T> iterable, int groupSize) {
		if (groupSize < 1) throw new IllegalArgumentException('groupSize must be > 0')
		
		val List<List<T>> list = newLinkedList(newLinkedList)
		
		iterable.fold(list) [ total, incoming |
			if (total.last.size == groupSize) total.add(newLinkedList(incoming))
			else total.last.add(incoming)
			total
		]
	}
	
	/** transforms a map into a list of pairs */
	def static <K, V> toPairs(Map<K, V> map) {
		map.entrySet.map[it.key -> it.value].toList
	}

	/** Convert a list of pairs to a map */
	def static <K, V> Map<K, V> toMap(Iterable<Pair<K, V>> pairs) {
		val map = newHashMap
		if(pairs.defined) pairs.forEach[map.put(key, value)]
		map
	}

	/** 
	 * Create a grouped index for a list of items. if the keys are unique, use toMap instead!
	 * <p>
	 * Example: val groups = levels.groupBy [ difficulty ] // creates a map with per difficulty level a list of levels
	 */
	def static <K, V> Map<K, List<V>> groupBy(Iterable<? extends V> list, (V)=>K indexFn) {
		val map = new HashMap<K, List<V>>
		list.forEach [
			val index = indexFn.apply(it)
			if (map.containsKey(index)) {
				val values = map.get(index)
				values.add(it)
			} else {
				val values = newLinkedList(it)
				map.put(index, values)
			}
		]
		map
	}

	/** Lets you map a pair using  */
	def static <K, V, R> map(List<Pair<K, V>> list, (K, V)=>R mapFn) {
		list.map [ mapFn.apply(key, value) ]
	}

	/** 
	 * Convert to a different type. will throw a class cast exception at runtime
	 * if you convert to the wrong type!
	 */
	def static <T> Iterable<T> mapAs(Iterable<?> iterable, Class<T> type) {
		iterable.map[it as T]
	}
	
	/**
	 * Flatten a list of keys -> list of pair values into more key->value pairs
	 */
	def static <K, V> Iterable<Pair<K, V>> flattenValues(Iterable<Pair<K, List<V>>> pairs) {
		val newList = newLinkedList
		pairs.forEach [ pair | pair.value?.forEach [ newList.add(pair.key->it) ] ]
		newList
	}

	// REDUCTION //////////////////////////////////////////////////////////////
	
	// count for each value how often it occurs
	// example: #[1, 1, 3, 2].count == #[1->2, 3->1, 2->1]
	def static <V> Map<V, Integer> count(Iterable<? extends V> values) {
		values.countBy[it]
	}

	// count the occurance of values, but you can tell how to identify doubles using the index/identity function
	// example: #[user1, user2, user3].countBy [ userId ]
	def static <K, V> Map<V, Integer> countBy(Iterable<? extends V> values, (V)=>K indexFn) {
		values.groupBy(indexFn).toPairs.map[value.head -> value.size].toMap
	}

	// alias for toMap for indexing a list of values	
	def static <K, V> Map<K, V> index(Iterable<? extends V> iterable, (V)=>K indexFn) {
		iterable.toMap[indexFn.apply(it)]
	}

	def static <T extends Number> sum(Iterable<? extends T> values) {
		var double total = 0
		for (T value : values) {
			total = total + value.doubleValue
		}
		total
	}

	def static <T extends Number> average(Iterable<? extends T> values) {
		values.sum / values.length
	}
	
	def static <T extends Double> median(Iterable<? extends T> values) {
		val sortedValues = values.sort
		switch length : sortedValues.size {
			case 0: throw new IllegalArgumentException('an empty list does not have a median')
			case 1: sortedValues.head
			case length % 2 == 0: (sortedValues.get(length/2 - 1) + sortedValues.get(length/2)) / 2
			default: sortedValues.get(length/2)
		}
	}
	
	// BOOLEAN CHECKS /////////////////////////////////////////////////////////

	/** Checks if any of the values is truthy */
	def static <T> boolean any(Iterable<? extends T> values) {
		for(value : values) {
			if(value.truthy) return true
		}
		false
	}

	/** Checks if all of the values are truthy */
	def static <T> boolean all(Iterable<? extends T> values) {
		for(value : values) {
			if(!value.truthy) return false
		}
		true
	}
	
	/** Checks if none of the values are truthy */
	def static <T> boolean none(Iterable<? extends T> values) {
		for(value : values) {
			if(value.truthy) return false
		}
		true
	}

	// IN CHECKS //////////////////////////////////////////////////////////////

	// check if an object is one of the following
	// example: 12.in(3, 4, 12, 6) == true
	def static <T> boolean in(T instance, T... objects) {
		instance.defined && objects.defined && objects.contains(instance)
	}
	
	def static <T> boolean in(T instance, Iterable<? extends T> objects) {
		// instance.defined && objects.defined && 
		objects.toList.contains(instance)
	}
	
	def static <T> boolean in(T instance, Iterator<? extends T> objects) {
		instance.defined && objects.defined && objects.toList.contains(instance)
	}

	// LIST OPERATORS /////////////////////////////////////////////////////////

	/** Create a new immutable list from this list that does not contain the value */
	def static <T> - (List<? extends T> list, T value) {
		list.uncat(value)
	}

	/** Create a new immutable list from a list and a value */
	def static <T> + (Iterable<? extends T> list, T value) {
		list.concat(value)
	}

	/** Create a new immutable list from this list that does not contain the value */
	def static <T> - (List<? extends T> list, List<? extends T> list2) {
		list.uncat(list2)
	}

	// FUNCTION OPERATORS /////////////////////////////////////////////////////

	// map with ->
	def static <T, R> -> (Iterable<? extends T> original, Functions.Function1<? super T, ? extends R> transformation) {
		original.map(transformation)
	}

	// filter with +
	def static <T>  + (Iterable<? extends T> unfiltered, Functions.Function1<? super T, Boolean> predicate) {
		unfiltered.filter(predicate)
	}

	// remove with -
	def static <T> - (Iterable<? extends T> unfiltered, Functions.Function1<? super T, Boolean> predicate) {
		unfiltered.filter [
			!predicate.apply(it)
		]
	}

	// negating a filter with !
	def static <T> Functions.Function1<? super T, Boolean> ! (
		Functions.Function1<? super T, Boolean> predicate) {
		[!predicate.apply(it)]
	}
	
	def static <T extends Comparable<? super T>> minSafe(T... values) { 
		try org.eclipse.xtext.xbase.lib.IterableExtensions.min(values) catch(NoSuchElementException it) null
	}
	
	def static <T extends Comparable<? super T>> maxSafe(T... values) { 
		try org.eclipse.xtext.xbase.lib.IterableExtensions.max(values) catch(NoSuchElementException it) null
	}

}
