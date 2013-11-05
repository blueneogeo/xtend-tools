package nl.kii.rx

import rx.Observer

class ObserverHelper<T> implements Observer<T> {
	
	var (T)=>void onNext
	var (Throwable)=>void onError
	var ()=>void onCompleted
	
	new() { }
	
	new((T)=>void onNext, ()=>void onCompleted, (Throwable)=>void onError) {
		this.onNext = onNext
		this.onCompleted = onCompleted
		this.onError = onError
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
