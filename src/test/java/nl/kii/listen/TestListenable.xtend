package nl.kii.listen

import nl.kii.listen.ListenableList
import org.junit.Test

import static extension nl.kii.rx.StreamExtensions.*
import static extension nl.kii.util.IterableExtensions.*
import static extension nl.kii.util.MapExtensions.*
import nl.kii.listen.ListenableMap

class TestListenable {
	
	@Test
	def void testList() {
		val list = new ListenableList<String>
		
		list << 'hi'
		
		list.stream.each [ println(it) ]
		
		list << 'welcome!' << 'Christian'
		
		list.remove('Christian')
		
	}

	@Test
	def void testMap() {
		val map = new ListenableMap<String, String>
		
		map.stream.each [ println(it) ]
		
		map << ('hello'->'world')
		map << ('hello'->'world 2')
		map.remove('hello')
		
	}
	
}
