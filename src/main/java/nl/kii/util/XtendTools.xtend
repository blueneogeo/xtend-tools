package nl.kii.util

import com.google.common.collect.ImmutableList
import com.google.common.collect.ImmutableSet
import java.io.Closeable
import java.io.Serializable
import java.util.HashMap
import java.util.HashSet
import java.util.List
import java.util.Map
import java.util.Set
import org.apache.commons.lang.SerializationUtils
import org.eclipse.xtext.xbase.lib.Pair
import org.slf4j.Logger

import static extension org.junit.Assert.*

class XtendTools {
	
	// CLONING
	
	/** 
	 * Clone an object using serialization. warning, this means it can be very
	 * slow compared to normal cloning. Benefit is that it will provide deep cloning
	 */
	def static <T extends Serializable> T cloneSerializable(T object) {
		SerializationUtils.clone(object) as T
	}
	
	// CLOSING
	
	/** Perform an operation on a closable, and close it when finished */
	def static <I extends Closeable> using(I closable, (I)=>void fn) {
		try {
			fn.apply(closable)
		} finally {
			closable.close
		}
	}

	/** Perform an operation on a closable, and close it when finished */
	def static <I extends Closeable, T> using(I closable, (I)=>T fn) {
		try {
			fn.apply(closable)
		} finally {
			closable.close
		}
	}

	def static <I extends Closeable, T> Opt<T> attemptUsing(I closable, (I)=>T fn) {
		try {
			using(closable, fn).option
		} catch(Throwable e) {
			error(e)
		}
	}

	// BOOLEAN CHECK EXTENSIONS ///////////////////////////////////////////////
	
	// alternative not null check
	// example: if(user.defined) { ... }
	def static <T> defined(Object o) {
		switch(o) {
			case null: false
			None<T>: false
			Err<T>: false
			default: true
		}		
	}

	// OPTION EXTENSIONS //////////////////////////////////////////////////////

	/**
	 * saves option importing
	 * example: api.getUser(userId).option // if getUser returns null, it will be None, otherwise Some<User>
	 */
	def static <T> Opt<T> option(T object) {
		Opt.option(object)
	}
	
	def static <T> Some<T> some(T object) {
		Opt.some(object)
	}
	
	def static <T> None<T> none() {
		new None<T>
	}
	
	def static <T> Err<T> error(Throwable t) {
		new Err<T>(t)
	}
	
	def static <T> Err<T> error() {
		new Err<T>()
	}

	/**
	 * wrap a call as an option (exception or null generates none)<p>
	 * example: val userOption = attempt [ api.getUser(userId) ] // if API throws exception, return None
	 */
	def static <T> Opt<T> attempt((Object)=> T fn) {
		try {
			fn.apply(null).option
		} catch (Exception e) {
			error(e)
		}
	}
	
	def static <I, T> I apply(I input, (I)=>void fn) {
		fn.apply(input)
		input
	}

	/** 
	 * Same as => but with optional execution and option result<p>
	 * example: normally you do: user => [ name = 'john' ]<p>
	 * but what if user is of type Option<User><p>
	 * then you can do: user.attempt [ name = 'john' ]<br>
	 * the assignment will only complete if there was a user
	 */
	def static <T, O> Opt<O> attempt(Opt<O> o, (O)=>T fn) {
		if(o.defined) fn.apply(o.value)
		o
	}

	/**
	 * Same as => but with optional execution and option result
	 * example: normally you do: user => [ name = 'john' ]
	 * but what if user is of type Option<User>
	 * then you can do: user.attempt [ name = 'john' ]
	 * the assignment will only complete if there was a user
	 * <p>
	 * This version also accept functions that have no result
	 */
	def static <T, O> Opt<O> attempt(Opt<O> o, (O)=>void fn) {
		if(o.defined) fn.apply(o.value)
		o
	}

	/** Transform an option into a new option using a function.
	 * The function allows you to transform the value of the passed option,
	 * saving you the need to unwrap it yourself
	 */
	def static <T, O> Opt<T> mapOpt(Opt<O> o, (O)=>T fn) {
		if(o.defined) fn.apply(o.value).option else none
	}

	/**
	 * conditionally execute a function, and return an option
	 * <p>
	 * example: val userOption = when(userId) [ api.getUser(userId) ]
	 */
	// 
	//  
	def static <T, I> Opt<T> ifTrue(boolean condition, (Object)=>T fn) {
		if(condition) fn.apply(null).option
		else none
	}

	def static <T, I> Opt<T> ifSome(Opt<I> o, (I)=>T fn) {
		if(o.defined) fn.apply(o.value).option
		else none
	}

	def static <T, I> Opt<T> ifEmpty(Opt<I> o, (I)=>T fn) {
		if(!o.defined) fn.apply(o.value).option
		else none
	}

	def static <T, I> Opt<T> ifError(Opt<I> o, (I)=>T fn) {
		if(o.hasError) fn.apply(o.value).option
		else none
	}

	// allows you to keep chaining when you have some chain parts that are optional.
	// example: val results = query.ifSome(afterDate) [| gt('date', afterDate) ].list
	def static <T> T ifTrue(T chain, boolean condition, (T)=>T fn) {
		if(condition) fn.apply(chain)
		chain
	}

	def static <T, V> T ifSome(T chain, Opt<V> o, (T)=>T fn) {
		if(o.defined) fn.apply(chain)
		chain
	}

	def static <T, V> T ifEmpty(T chain, Opt<V> o, (T)=>T fn) {
		if(!o.defined) fn.apply(chain)
		chain
	}

	def static <T, V> T ifError(T chain, Opt<V> o, (T)=>T fn) {
		if(o.hasError) fn.apply(chain)
		chain
	}

	// OPTIONAL FALLBACK EXTENSIONS ///////////////////////////////////////////
	
	// provide a fallback value if o is undefined
	// example: val user = foundUser.or(defaultUser)
	def static <T> T or(T o, T fallback) {
		if(o.defined) o else fallback
	}

	// provide a fallback value if o is undefined 
	// example: val user = api.getUser(12).or(defaultUser) // getUser returns an Option<User>
	def static <T> T or(Opt<T> o, T fallback) {
		if(o.defined) o.value else fallback
	}

	// run a fallback function if o is undefined
	// example: val user = foundUser.or [ api.getDefaultUser() ]
	def static <T> T or(T o, (Object)=>T fallbackFn) {
		if(o.defined) o else fallbackFn.apply(null)
	}
	
	// run a fallback function if o is undefined
	// example: val user = api.getUser(12).or [ api.getDefaultUser() ] // getUser returns an Option<User>
	def static <T> T or(Opt<T> o, (Object)=>T fallbackFn) {
		if(o.defined) o.value else fallbackFn.apply(null)
	}

	def static <T> T orNull(T o) {
		if(o.defined) o else null
	}
	
	def static <T> T orNull(Opt<T> o) {
		if(o.defined) o.value else null
	}
	
	def static <T> T orThrow(Opt<T> o) {
		switch(o) {
			Err<T>: throw o.exception
			None<T>: throw new NoneException
			Some<T>: o.value
		}
	}

	// throw the result of the exceptionFn if o is not defined
	// example: val user = api.getUser(12).orThrow [ new UserNotFoundException ] // getUser can return null
	def static <T> T orThrow(T o, (Object)=>Throwable exceptionFn) {
		if(o.defined) o else throw exceptionFn.apply(null)
	}

	// try to unwrap an option, and if there is nothing, calls the exceptionFn to get a exception to throw
	// example: val user = api.getUser(12).orThrow [ new UserNotFoundException ] // getUser returns an option
	def static <T> T orThrow(Opt<T> o, (Object)=>Throwable exceptionFn) {
		if(o.defined) o.value else throw exceptionFn.apply(null)
	}

	// IN CHECKS //////////////////////////////////////////////////////////////

	// check if an object is one of the following
	// example 12.in(#[3, 4, 12, 6]) == true
	def static <T> boolean in(T instance, List<T> objects) {
		if(instance.defined && objects.defined) objects.contains(instance) else false
	}

	// check if an object is one of the following
	// example: 12.in(3, 4, 12, 6) == true
	def static <T> boolean in(T instance, Object... objects) {
		if(instance.defined && objects.defined) objects.contains(instance) else false
	}
	
	// LIST/ITERABLE EXTENSIONS ///////////////////////////////////////////////

	def static <T> List<T> list(Class<T> cls) {
		newLinkedList
	}

	def static <T> List<T> list(T... objects) {
		newImmutableList(objects)
	}

	def static <T> Iterable<T> each(Iterable<T> iterable, (T)=>void fn) {
		iterable.forEach(fn)
		iterable
	}

	/** Convert a list of options into actual values, filtering out the none and error values.
		Like filterNull, but then for a list of Options */
	def static <T> Iterable<T> filterEmpty(Iterable<? extends Opt<T>> iterable) {
		iterable.map [ orNull ].filterNull
	}
	
	def static <T> Iterable<? extends Opt<T>> filterError(Iterable<? extends Opt<T>> iterable) {
		iterable.filter [ !hasError ]
	}

	/** Triggers the passed or function for each error in the list,
	 * handy for tracking errors for example:
	 * <pre>usersIds.attemptMap [ get user ].onError [ error handling ].filterEmpty</pre>
	 */
	def static <T> Iterable<? extends Opt<T>> onError(Iterable<? extends Opt<T>> iterable, (Err<T>)=>void errorHandler) {
		iterable.filter [ hasError ].each [ errorHandler.apply(it as Err<T>) ]
		iterable
	}

	/** Triggers the passed or function for each none in the list,
	 * handy for tracking empty results, for example:
	 * <pre>usersIds.map [ get user ].onNone [ println('could not find user') ].filterNone</pre>
	 */
	def static <T> Iterable<? extends Opt<T>> onNone(Iterable<? extends Opt<T>> iterable, (None<T>)=>void noneHandler) {
		iterable.filter [ hasNone ].each [ noneHandler.apply(it as None<T>) ]
		iterable
	}

	/** Remove all double values in a list, turning it into a list of unique values */
	def static <T> Iterable<T> distinct(Iterable<T> values) {
		values
			.groupBy[it]
			.toPairs
			.map [ value.head ]
	} 

	/** Always returns an immutable list, even if a null result is passed. handy when chaining, eliminates null checks
	 * <pre>example: getUsers.filter[age>20].list</pre>
	 */
	def static <T> List<T> toList(Iterable<T> iterable) {
		if(!iterable.defined) newImmutableList
		else iterable.iterator.toList.immutableCopy
	}

	/** Always returns an immutable set, even if a null result was passed. handy when chaining, eliminates null checks.	
	 * note: double values will be removed!
	 */
	def static <T> Set<T> toSet(Iterable<T> iterable) {
		if(!iterable.defined) newHashSet else {
			val uniques = iterable.distinct.toList
			new HashSet<T>(uniques).immutableCopy
		}
	}

	// transforms a map into a list of pairs
	def static <K, V> Iterable<Pair<K, V>> toPairs(Map<K, V> map) {
		map.entrySet.map [ it.key -> it.value ]
	}
	
	// convert a list of pairs to a map
	def static <K, V> Map<K, V> toMap(Iterable<Pair<K, V>> pairs) {
		val map = newHashMap
		if(pairs.defined) pairs.forEach [ map.put(key, value) ]
		map
	}
	
	// create a grouped index for a list of items. if the keys are unique, use toMap instead!
	// example: val groups = levels.groupBy [ difficulty ] // creates a map with per difficulty level a list of levels 
	def static <K, V> Map<K, List<V>> groupBy(Iterable<V> list, (V)=>K indexFn) {
		val map = new HashMap<K, List<V>>
		list.forEach [
			val index = indexFn.apply(it)
			if(map.containsKey(index)) {
				val values = map.get(index)
				values.add(it)
			} else {
				val values = newLinkedList(it)
				map.put(index, values)
			}
		]
		map
	}
	
	// count for each value how often it occurs
	// example: #[1, 1, 3, 2].count == #[1->2, 3->1, 2->1]
	def static <V> Map<V, Integer> count(Iterable<V> values) {
		values.countBy [ it ]
	}

	// count the occurance of values, but you can tell how to identify doubles using the index/identity function
	// example: #[user1, user2, user3].countBy [ userId ]
	def static <K, V> Map<V, Integer> countBy(Iterable<V> values, (V)=>K indexFn) {
		values
			.groupBy(indexFn)
			.toPairs
			.map [ value.head -> value.size ]
			.toMap
	}
	
	// alias for toMap for indexing a list of values	
	def static <K, V> Map<K, V> index(Iterable<V> iterable, (V)=>K indexFn) {
		iterable.toMap[ indexFn.apply(it) ]
	}
	
	def static <T, R> Iterable<Opt<R>> mapOpt(Iterable<Opt<T>> iterable, (T)=>R fn) {
		iterable.map [ mapOpt(fn) ]
	}
	
	// try to map the values in the iterable, and give back a list of options instead of direct values
	def static <T, R> Iterable<Opt<R>> attemptMap(Iterable<T> iterable, (T)=>R fn) {
		iterable.map [
			val o = it
			attempt [ fn.apply(o) ]
		]
	}
	
	// MORE LIST EXTENSIONS
	
	def static <T extends Number> sum(Iterable<T> values) {
		var double total = 0 
		for(T value : values) { total = total + value.doubleValue }
		total
	}

	def static <T extends Number> average(Iterable<T> values) {
		values.sum / values.length
	}

	// LOGGING EXTENSIONS /////////////////////////////////////////////////////

	// create a logging wrapper
	// example: extension Log logger = class.logger.wrapper
	def static wrapper(Logger logger) {
		new Log(logger, null)
	}

	// create a logging wrapper
	// example: extension Log logger = class.logger.wrapper
	def static wrapper(Logger logger, String name) {
		new Log(logger, name)
	}
	
	// print something. example: o.print
	def static print(Object o) {
		println(o)
	}

	// print a list in seperate lines
	def static print(Object ...o) {
		o.forEach[ println(it) ]
	}
	
	// print the result of a function
	// example: print [| new User() ]
	def static <T> print(=>T o) {
		println(o.apply)
	}
	
	// loses the | requirement in the function
	// example: print [ new User() ]
	def static <T> print((Object)=>T o) {
		print(o.apply(null))
	}
	
	// ASSERT EXTENSIONS //////////////////////////////////////////////////////
	
	def static <T> void assertNone(Opt<T> option) {
		option.hasSome.assertFalse
	}
	
	def static <T> void assertSome(Opt<T> option) {
		option.hasSome.assertTrue
	}

	def static <T> void assertSome(Opt<T> option, T value) {
		option.assertSome
		value.assertEquals(option.value)
	}
	
	// IMMUTABLE COLLECTIONS //////////////////////////////////////////////////
	
	def static <T> addSafe(List<T> list, T value) {
		ImmutableList.builder.addAll(list).add(value).build
	}
	
	def static <T> addSafe(Set<T> set, T value) {
		ImmutableSet.builder.addAll(set).add(value).build
	}

}
