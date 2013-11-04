package nl.kii.rx

import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.atomic.AtomicReference
import org.eclipse.xtext.xbase.lib.Functions.Function0
import rx.Notification
import rx.Observer
import rx.Subscription
import rx.operators.SafeObservableSubscription
import rx.subjects.PublishSubject
import rx.subscriptions.Subscriptions
import rx.Observable.OnSubscribeFunc

import static nl.kii.util.SyncExtensions.*

import static extension nl.kii.rx.StreamExtensions.*

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
class RxSubject<T> extends PublishSubject<T> implements Function0<T> {
	
	val current = new AtomicReference<T>
	
	protected new(OnSubscribeFunc<T> onSubscribe, ConcurrentHashMap<Subscription,Observer<? super T>> observers, AtomicReference<Notification<? extends T>> terminalState) {
		super(onSubscribe, observers, terminalState)
	}
	
	override static <T> RxSubject<T> create() {
        val observers = new ConcurrentHashMap<Subscription, Observer<? super T>>
        val terminalState = new AtomicReference<Notification<? extends T>>

        val OnSubscribeFunc<T> onSubscribe = [
    		// function to check terminal state
            val (Observer<? super T>)=>Subscription checkTerminalState = [
            	val n = terminalState.get
                if (n != null) {
                    // we are terminated to immediately emit and don't continue with subscription
                    if (n.onCompleted) onCompleted
                    else onError(n.throwable)
                    Subscriptions.empty
                } else null
            ]
            
            // shortcut check if terminal state exists already
            val s = checkTerminalState.apply(it)
            if(s != null) return s

            val subscription = new SafeObservableSubscription()
			val Subscription unsubscription = [| observers.remove(subscription)	]
			subscription.wrap(unsubscription)

            /**
             * NOTE: We are synchronizing to avoid a race condition between terminalState being set and
             * a new observer being added to observers.
             *
             * The synchronization only occurs on subscription and terminal states, it does not affect onNext calls
             * so a high-volume hot-observable will not pay this cost for emitting data.
             *
             * Due to the restricted impact of blocking synchronization here I have not pursued more complicated
             * approaches to try and stay completely non-blocking.
             */
             sync(terminalState) [|
                // check terminal state again
                val s2 = checkTerminalState.apply(it)
                if (s2 != null) return s2
                // on subscribe add it to the map of outbound observers to notify
                observers.put(subscription, it)
                subscription
             ]
        ]

        val subject = new RxSubject<T>(onSubscribe, observers, terminalState)
        subject.each [ subject.current.set(it) ]
        subject
    }

	
	override apply() {
		current.get
	}
	
}
