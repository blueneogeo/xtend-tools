package nl.kii.rx

import rx.Observable
import rx.Scheduler

import static extension nl.kii.util.OptExtensions.*

class Subscriber<T> {

	val Observable<T> stream	
	var (T)=>void onEach
	var =>void onFinish
	var (Throwable)=>void onError
	var Scheduler scheduler
	
	new(Observable<T> stream) {
		this.stream = stream
	}
	
	def each((T)=>void onEach) {
		this.onEach = onEach
		this
	}
	
	def onFinish((Object)=>void onFinish) {
		this.onFinish = [| onFinish.apply(null) ]
		this
	}
	
	def onError((Throwable)=>void onError) {
		this.onError = onError
		this
	}
	
	def scheduleOn(Scheduler scheduler) {
		this.scheduler = scheduler
		this
	}

	def start() {
		if(onEach.defined) {
			if(onError.defined) {
				if(onFinish.defined) {
					if(scheduler.defined) {
						stream.subscribe(onEach, onError, onFinish, scheduler)
					} else stream.subscribe(onEach, onError, onFinish)
				} else stream.subscribe(onEach, onError)
			} else stream.subscribe(onEach)
		}
	}
	
}
