package nl.kii.util

import java.util.Map
import java.util.Map.Entry
import java.util.List

class MapExtensions {

	// OPERATOR OVERLOADING ///////////////////////////////////////////////////

	def static <K, V> += (Map<K, V> map, Pair<K, V> pair) {
		map.put(pair.key, pair.value)
		map
	}

	def static <K, V> += (Map<K, V> map, Entry<K, V> entry) {
		map.put(entry.key, entry.value)
		map
	}

	// MAP<MAP> METHODS ///////////////////////////////////////////////////////

	def static <K, K2, V> add(Map<K, Map<K2, V>> map, Pair<K, Pair<K2, V>> pairPair) {
		map.put(pairPair.key, pairPair.value.key, pairPair.value.value)
	}

	def static <K, K2, V> put(Map<K, Map<K2, V>> map, K key1, K2 key2, V value) {
		val valueMap = if(map.containsKey(key1)) map.get(key1) else newHashMap
		valueMap.put(key2, value)
	}
	
	def static <K, K2, V> remove(Map<K, Map<K2, V>> map, K key1, K2 key2) {
		val valueMap = map.get(key1)
		if(valueMap != null) valueMap.remove(key2)
	}
	
	// MAP<LIST> METHODS //////////////////////////////////////////////////////
	
	/** Add a value to a multimap structure */
	def static <K, V> void add(Map<K, List<V>> map, K key, V value) {
		if(map.containsKey(key)) map.get(key).add(value)
		else {
			map.put(key, newLinkedList)
			map.add(key, value) // recurse
		}
	}

	// ITERATIONS /////////////////////////////////////////////////////////////
	
	/** Iterate through a map as if it were a list, but with key and value */
	def static <K, V> forEach(Map<K, V> map, (K, V)=>void fn) {
		map.entrySet.map[key -> value].forEach[fn.apply(key, value)]
		map
	}
	
	// MAPPING ////////////////////////////////////////////////////////////////

	/** 
	 * Map both the keys and values of a map,
	 * using a mapping function that returns a pair
	 * <pre>
	 * Example:
	 * #{ 1->5, 2->6 }.map [ k, v | k+1->v+1 ]
	 * Result:
	 * #{ 2->6, 3->7 }
	 * </pre>
	 */	
	def static <K, V, K2, V2> Map<K2, V2> map(Map<K, V> map, (K, V)=>Pair<K2, V2> mapFn) {
		val newMap = newHashMap
		for(key : map.keySet) {
			val pair = mapFn.apply(key, map.get(key))
			newMap.put(pair.key, pair.value)
		}
		newMap
	}

}
