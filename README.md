# xtend-tools

Some nice tools and Xtend extensions that make life with Xtend better

## Getting Started

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
	import nl.kii.util.Log

	class MyClass {
		extension Log logger = class.logger.wrapper

		def someFunction() {
			debug['minor implementation detail']
			info['something happened!']
			warn['watch out!']
			error['crashed!']
		}
	}

The lambda expression/function will only be called if necessary, which helps performance.

You can also add a name to the logger when you create it:

	extension Log logger = class.logger.wrapper('somename')

When you do this, this message will be put in front of every log statement made by this logger. This can be handy when you want to distinguish easily between types of messages in your log.

## Optional Programming

A problem in Java is catching NullPointerExceptions. You end up with a lot of NullPointerException checks, or with code that throws one while your program runs. Languages like Scala use the idea of an Option to solve this. It forces you to catch these errors at compile time. By marking something an Opt<T> instead of a T, you are saying that the result is optional, and that the programmer should handle the case of no result.

### Opt, Some, None, Err

An Opt<T> can be a Some<T>, None<T> or Err<T>. If it is a Some, you can use the value method to get the value. The option extensions let you create an option from a value really easily. For example:

	import static extension nl.kii.util.OptExtensions.*
	…
	val o = new Some(12)
	o.value == 12 // true

	some(12).value == 12 // extension shortcut
	12.option.value == 12 // extension shortcut

### .option and .or Extensions

The .option extension also works on null values. This allows you to wrap calls that can return null into options. For example, say that you have a method:

	def User getUser(long userId) { … } // may return null

You can then either choose to alter the method itself:

	def Opt<User> getUser(long userId) {
		.. original code ..
		return user.option
	}

Or if this is impractical, wrap it when you make the call:

	val Opt<User> result = getUser(userId).option

All this becomes useful when you use it as the result of a function:

	val user = getUser(12).or(defaultUser)

Here findUser returns an Opt. The .or extension method gives either the found value, or if there is no value, a default. There is also one that executes a closure:

	val user = findUser(12).or [ loadDefaultUser() ]

These can also be chained:

	val user = findUser(12)
		.or [ findUser(defaultUserId) ]
		.orThrow [ new Exception('help!') ]

### Attempt

You can also catch errors this way, in case findUser were to throw an exception if there was no user found:

	val Opt<User> user = attempt [ findUser(id) ]

### Conditional Processing

To perform conditional processing (user is an Opt<User>):

	ifSome(user) [ ..do something with the user.. ]

### Optional Mapping

To map a value that may not exist:

	val Opt<Integer> age = user.mapOpt [ it.age ] // user is an  Opt<User>

This is just a selection. For more extensions, check the source of OptExtensions.xtend

## List Operations

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
		.map [ value ] // getting just the occurrences
		.avg // average the occurrences

As you can see, the difference between the standard List.forEach in Xtend and List.each here is that you can chain it.

See for more operations IteratorExtensions.xtend

### List Operator Overloading

You can perform each with an overload:

	users.each [ … ]
	users >> [ … ] // same thing

You can also add to a list with an overload:

	list.add(3)
	list.add(5)
	list << 3 << 5 // almost the same thing

What is different is that the overload either calls List.add or IteratorExtensions.safeAdd, depending on whether the list is immutable. If it is immutable, it will perform an immutable add.

This means that if your list is immutable, you have to catch the result:

	// Integer.string creates an immutable list
	val list = Integer.string
	val list2 = list << 2 << 5 // catch result in list2

## Streams

RXJava is a library written by NetFlix that allows for streams of data, much like Java 8 has introduced with the StreamAPI. RxExtensions.xtend contains helper extensions to make working with streams in Xtend very user-friendly.

A stream is like a list that keeps on filling. If you consider a normal List<T> to be something that you 'pull' data from, you can see a stream as a list that has pushed data into it. You never know when a new item is being pushed onto the stream. That is why you subscribe a lambda/closure to a stream to handle an incoming result. 

Streams are a very nice way of reasoning about asynchronous data, and for making your code non-blocking. For more information, check the RXJava documentation.

https://github.com/Netflix/RxJava/wiki

### defining a new stream

You can define a new stream like this:

	import static extension nl.kii.util.RxExtensions.*
	...
	val stream = Integer.stream

You can also create a stream directly out of values:

	val stream = #[1, 5, 2, 6].stream

### Pushing something onto a stream

Pushing into a stream is like calling a function:

	stream.apply(12)
	stream << 12 // same thing

### Responding to values being pushed onto the stream

When a new value is pushed onto a stream, you can react to it like this:

	stream.each [ println('got value ' + it) ]

There is an operator overload as well:

	stream >> [ println('got value ' + it) ]

### Stream Operations

As you see this looks very much like the List methods. You can apply mappings, filtering, and more, much like with a list. Much of the strength of stream programming comes from the fact that you can apply many of these transformation functions on data that has not yet arrived, and as needed. This makes streams really well suited for any asynchronous programming. For example:

	val stream = Integer.stream
	val printer = String.stream

	stream
		.filter [ it > 5 ]
		.map [ 'value: ' + it ]
		.each(printer) // into another stream!

	printer.each [ println(it) ]

These mimic the List/Iterable API. What I call a stream is actually a RXJava Subject, which in turn is an Observable. RX gives you a huge amount of clever manipulations on these streams. To see all of them, visit the RXJava documentation:

http://netflix.github.io/RxJava/javadoc/rx/Observable.html

### Splitting Streams

Use the stream.split command to create a new stream from an existing one. For example, say you want to listen for tweets coming in in realtime, but do something different depending on if they are known users:

	val tweetStream = twitterAPI.streamUserTweets(twitterUserID)
		.filter [ language == 'EN' ] // only english tweets

	// now we want to split from here:

	// save tweets from our own users
	tweetStream.split
		.filter [ userId == userAPI.isKnownUser(it) ]
		.map [ message ]
		.each [ messageDB.save(it) ]
	// and analyse tweets from others
	tweetStream.split
		.filter [ userId != userAPI.isKnownUser(it) ]
		.map [ userId -> message ]
		.each [ analyser.process(it) ]### Closing a Stream

To complete a stream, call the complete method:

	stream.complete

You can also listen for a stream to complete:

	stream.onComplete [ … ]

## Error Handling

A normal problem in async programming is that if you have an error, this can be thrown in a different thread than your UI, and you have no way of normally catching it. RX will catch and carry the error forward through the stream, much like the closing of the stream, and you can listen for the error at the end:

	stream.onError [ … do error handling … ]

You can also manually send an error to a stream:

	stream.error(throwable)

## Promises

A stream of just 1 value is a promise. Once apply is called on a promise, it is considered complete. It is much like a Future. However, you can reason about them in the same way as a stream.

To create a promise:

	val p = Integer.promise

To respond to it, you can use any normal stream operator:

	p.map[api.getUser(it)].filter[isLoggedIn].each[sayWelcome(it)]

Then to put something into it:

	p.apply(4) // this also completes the promise
	p << 4 // same thing

You can also directly convert any Future<T> into a promise. For example:

	Future<User> future = loadUserFromNetwork()
	val promise = future.promise
	promise.each [ println('got user ' + it) ]

There are many more operations. See RxExtensions.xtend for more.

### Combining with Opt

If you apply an Opt<T> on a stream (or promise), this has the following effect:

- if it is a Some<T>, it will apply the value of the some to the stream
- if it is a None<T>, it will complete the stream
- if it is an Err<T>, it will tell the stream there was an error

The value of this is that you can make lists of Opt<T> which will fully represent the stream of data.

	val stream = Long.stream << 4 << 2 << 5 << none // end the stream
	stream >> printUserStream // throw the result into another stream for async processing


