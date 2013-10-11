package nl.kii.util

import rx.Observable

interface Streamable<T> {
	
	def Observable<T> stream()
	
}