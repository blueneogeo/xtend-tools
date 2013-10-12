# xtend-tools

Some nice tools and Xtend extensions that make life with Xtend better

# Getting Started

If you use maven or gradle, the dependency is the following:

	nl.kii.util:xtend-tools:2.1-SNAPSHOT

To use, add the following import statements at the top of your Xtend source file:

	import static extension nl.kii.util.CloseableExtensions.*
	import static extension nl.kii.util.IterableExtensions.*
	import static extension nl.kii.util.LogExtensions.*
	import static extension nl.kii.util.ObjectExtensions.*
	import static extension nl.kii.util.OptExtensions.*
	import static extension nl.kii.util.RxExtensions.*

Not all are necessary, but you can optimise the imports in Eclipse afterwards.

## Logging

To use the logging wrapper, at the top of your class file, do the following:

	import static extension nl.kii.util.LogExtensions.*
	import static extension org.slf4j.Logger

	class MyClass {
		extension Log logger = class.logger.wrapper

		def someFunction() {
			debug['minor implementation detail']
			info['something happened!']
			warn['watch out!']
			error['crashed!']
		}
	}

The delta/function will only be called if necessary, which helps performance.

## Optional Programming

A problem in Java is catching NullPointerExceptions. You end up with a lot of NullPointerException checks, or with code that bombs. Languages like Scala use the idea of an Option to solve this.

An Opt<T> can be a Some<T>, None<T> or Err<T>. If it is a Some, you can use the value method to get the value. The option extensions let you create an option from a value really easily. For example:

	import static extension nl.kii.util.OptExtensions.*
	…
	val o = new Some(12)
	o.value == 12 // true

	some(12).value == 12 // extension shortcut
	12.option.value == 12 // extension shortcut

The .option extension also works on null values. All this becomes useful when you use it as the result of a function:

	def Opt<User> findUser(long userID) { … }

	val user = findUser(12).or(defaultUser)

Here findUser returns an Opt. The .or extension method gives either the found value, or if there is no value, a default. There is also one that executes a closure:

	val user = findUser(12).or [ loadDefaultUser() ]

These can also be chained:

	val user = findUser(12)
		.or [ findUser(defaultUserId) ]
		.orThrow [ new Exception('help!') ]

You can also catch errors this way, in case findUser were to throw an exception if there was no user found:

	val Opt<User> user = attempt [ findUser(id) ]

And perform conditional processing:

	ifSome(user) [ ..do something with the user.. ]

And mapping on a value that may not exist:

	val Opt<Integer> age = user.mapOpt [ it.age ] // user is an  Opt<User>

For more extensions, check the source of OptExtensions.xtend

# List Operations

Lists have been augmented with Opt and attempt operations as well: (silly example!)

	api.getUsers()
		.attemptMap [ ..do something that may throw an exception.. ]
		.mapOpt [ userName ] // get the usernames, only if there is a value
		.filterEmpty // removes the errors
		.count // count how often each name occurs: List<Pair<String, Int>>
		.toMap // becomes Map<String, int>
		.toPairs // back to List<Pair<String, Int>>
		.each [ println('name:' + key) ]
		.each [ println('occurrence:' + value) ]
		.map(value) // getting just the occurrences
		.avg // average the occurrences

See for more operations IteratorExtensions.xtend

# Streams

RXJava allows for streams of data, much like Java 8 has introduced with the StreamAPI. RxExtensions.xtend contains helper extensions to make working with streams in Xtend very user-friendly.

A stream is like a list that keeps on filling. That makes a list 'pull' and a stream is 'push'. You never know when a new item is being pushed onto the stream. That is why you subscribe a closure to a stream to handle an incoming result. Streams are a very nice way of reasoning about asynchronous data, and for making your code non-blocking. For more information, check the RXJava documentation.

## defining a new stream

You can define a new stream like this:

	import static extension nl.kii.util.RxExtensions.*
	...
	val stream = Integer.stream

You can also create a stream directly out of values:

	val stream = #[1, 5, 2, 6].stream

## Pushing something onto a stream

	stream.apply(12)

## Responding to values being pushed onto the stream

	stream.each [ println('got value ' + it) ]

As you see this looks very much like the List methods. You can apply mappings, filtering, and more, much like with a list:

	val stream = Integer.stream
	val printer = String.stream

	stream
		.filter [ it > 5 ]
		.map [ 'value: ' + it ]
		.each(printer) // into another stream!

	printer.each [ println(it) ]

## Closing a Stream

To complete a stream, call the complete method:

	stream.complete

You can also listen for a stream to complete:

	stream.onComplete [ … ]

## Promises

A stream of just 1 value is a promise. Once apply is called on a promise, it is considered complete. It is much like a Future. However, you can reason about them in the same way as a stream. You can also directly convert a Future<T> into a promise. For example:

	Future<User> future = loadUserFromNetwork()
	val promise = future.promise
	promise.each [ println('got user ' + it) ]
