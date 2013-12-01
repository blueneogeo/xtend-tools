package nl.kii.util

import java.util.Map
import java.util.Map.Entry

class MapExtensions {
	
    def static <K, V> operator_doubleLessThan(Map<K, V> map, Pair<K, V> pair) {
    	map.put(pair.key, pair.value)
    }	
	
    def static <K, V> operator_doubleLessThan(Map<K, V> map, Entry<K, V> entry) {
    	map.put(entry.key, entry.value)
    }	

    def static <K, V> operator_doubleGreaterThan(Map<K, V> map, (Entry<K, V>)=>void fn) {
        map.entrySet.forEach(fn)
        map
    }
    
}