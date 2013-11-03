package nl.kii.rx

import rx.Observable

interface Streamable<T> {
	
	def Observable<T> stream()
	
}