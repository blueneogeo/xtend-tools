package nl.kii.rx

import rx.subjects.BehaviorSubject
import java.util.concurrent.atomic.AtomicReference
import rx.Observable.OnSubscribeFunc
import java.util.concurrent.ConcurrentHashMap
import rx.Subscription
import rx.operators.SafeObservableSubscription
import org.eclipse.xtext.xbase.lib.Functions.Function0
import rx.Observer

/**
 * Subject that publishes the most recent and all subsequent events to each subscribed {@link Observer}.
 * Extends a BehaviorSubject, but also implements ()=>T, letting you always get the last
 * value that it was passed. This means you can always simply call this function and use
 * it as a normal variable in your code, much like an AtomicReference (actually it wraps
 * an AtomicReference).
 * <p>
 * <img src="https://raw.github.com/wiki/Netflix/RxJava/images/rx-operators/S.BehaviorSubject.png">
 * <p>
 * Example usage:
 * <p>
 * <pre> {@code

	// create it via an extension
	val visitors = 0.observe
	 
	// you can respond to it, like an observable
	visitors >> [ println('got new value' + it ]
	
	// and manipulate it like a subject
	visitors << 2
	
	// but you can also use it like a variable
	println('current visitor count is ' + visitors.apply)
	 
	// or increment it in this case:
	visitors << visitors.apply + 1
	 
	// its strength is compounded in combination with a computed observable:
	val otherVisitors = 0.observe
	// computed is an observable which gets a new evaluated value if visitors or othervisitors changes
	val computed = [ visitors.apply + 4 + otherVisitors.apply.length ].observe(visitors, otherVisitors)

  } </pre>
 *
 * @param <T>
 */
class ObservedValue<T> extends BehaviorSubject<T> implements Function0<T> {
	
	AtomicReference<T> current
	
    /**
     * Creates a {@link BehaviorSubject} which publishes the last and all subsequent events to each
     * {@link Observer} that subscribes to it.
     *
     * @param defaultValue
     *            The value which will be published to any {@link Observer} as long as the
     *            {@link BehaviorSubject} has not yet received any events.
     * @return the constructed {@link BehaviorSubject}.
     */
    override static <T> ObservedValue<T> createWithDefaultValue(T defaultValue) {
        val observers = new ConcurrentHashMap<Subscription, Observer<? super T>>();

        val currentValue = new AtomicReference<T>(defaultValue);

		val OnSubscribeFunc<T> onSubscribe = [ observer |
            val observableSubscription = new SafeObservableSubscription
			val Subscription subscription = [|
				observers.remove(observableSubscription)
			]
			observableSubscription.wrap(subscription)

            observer.onNext(currentValue.get);

            // on subscribe add it to the map of outbound observers to notify
            observers.put(subscription, observer)
            subscription
		]

        new ObservedValue<T>(currentValue, onSubscribe, observers)
    }

	protected new(AtomicReference<T> currentValue, OnSubscribeFunc<T> onSubscribe, ConcurrentHashMap<Subscription,Observer<? super T>> observers) {
		super(currentValue, onSubscribe, observers)
		this.current = currentValue
	}
	
	override apply() {
		current.get
	}
	
}
