package nl.kii.util

import java.util.Map
import java.util.Map.Entry

class MapExtensions {

	def static <K, V> += (Map<K, V> map, Pair<K, V> pair) {
		map.put(pair.key, pair.value)
		map
	}

	def static <K, V> += (Map<K, V> map, Entry<K, V> entry) {
		map.put(entry.key, entry.value)
		map
	}

	def static <K, K2, V> add(Map<K, Map<K2, V>> map, Pair<K, Pair<K2, V>> pairPair) {
		map.put(pairPair.key, pairPair.value)
	}

	def static <K, K2, V> put(Map<K, Map<K2, V>> map, K key, Pair<K2, V> value) {
		val valueMap = {
			val existing = map.get(value.key)
			if(existing != null) existing
			else map.put(key, newHashMap)
		}
		valueMap.put(value.key, value.value)
	}
	
	def static <K, V> forEach(Map<K, V> map, (K, V)=>void fn) {
		map.entrySet.map[key -> value].forEach[fn.apply(key, value)]
		map
	}

}
