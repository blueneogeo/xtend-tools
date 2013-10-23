package nl.kii.util

import rx.Observer

class ObserverHelper<T> implements Observer<T> {
	
	var (T)=>void onNext
	var (Throwable)=>void onError
	var ()=>void onCompleted
	
	new() { }
	
	new((T)=>void onNext, (Throwable)=>void onError, ()=>void onCompleted) {
		this.onNext = onNext
		this.onError = onError
		this.onCompleted = onCompleted
	}
	
	override onCompleted() {
		onCompleted.apply
	}
	
	override onError(Throwable e) {
		onError.apply(e)
	}
	
	override onNext(T v) {
		onNext.apply(v)
	}
	
}
