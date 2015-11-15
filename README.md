# xtend-tools

Some tools and Xtend extensions that make life with the Xtend programming language better:

- @NamedParams: named and optional parameters
- Options: helps avoid NullpointerExceptions
- Easy date/time manipulation
- List operations and shortcuts
- SL4J Logging wrapper: allows more efficient and compact logging

Note: Promises and Streams have been moved to the xtend-async project. 

For more information about the Xtend language: http://www.eclipse.org/xtend/

## Getting Started

If you use maven or gradle, the dependency is the following:

	com.kimengi.util:xtend-tools:3.1-SNAPSHOT

Note: currently this library is not yet on MavenCentral.

## NamedParams

A drawback in both Java and Xtend is that constructors and methods can have a lot of parameters, which are then often replaced by setters. However that means a lot of new properties, and you lose immutability.

By using the @NamedParams Active Annotation, you can set your parameters using a closure.

### The Problem

For example, you have this existing User constructor:

	new(String name, String owner, int age, int duration, boolean isActive, boolean isAdmin) {
		// some init code
	}

Calling it is a pain:

	// what does each parameter mean?
	new User(‘John’, ‘Mary’, 40, 235, true, false)

So you may make a shortcut constructor:

	// an extra constructor for most cases
	new(String name, int age) {
		this(name, null, age, 10, true, false)
	}

All a lot of work, especially if more that one parameter is optional. Also, the null is dangerous. You would prefer to use an Optional type here, but setting that is more work.

### Using @NamedParams

@NamedParams can be used for both methods and constructors. This is how you can implement the above long constructor:

	@NamedParams
	new(String name, Opt<String> owner, Integer age, @I(10) int duration, @B(true) boolean isActive, @B(false) boolean isAdmin) { 
		// some init code
	}

In short, you annotate it with @NamedParams, and use annotations  for parameters to indicate if they have a default value or if they are options. Nothing may be null.

The default annotations are:

- @I(defaultValue) for int and Integer
- @B(defaultValue) for boolean and Boolean
- @L(defaultValue) for long and Long
- @D(defaultValue) for double and Double
- @S(defaultValue) for String

The @NamedParams method creates some extra methods for you in the class, along with a parameters class.

You can then use it like this:

	new User [ 
		name = ‘John’
		admin = ‘Mary’
		age = 40
		duration = 235
		active = true
		admin = false
	]

Notice that you can set the admin property directly as a String, using a setter method on the closure. It will set the option for you.

You can also call the constructor like this:

	new User [
		name = ‘John’
		age = 40
	]

Now admin will be None<String>, duration will be 10, active will be true, and admin will be false.

If you fail to set name or age, you will get a NullPointerException at runtime, before your constructor is called.

#### Pinning a Parameter

To use a method as an extension method, you need the first parameter to be fixed. For example:

	def static save(Database db, String key, Role role, Security security) { … }

Which can then be called like this:

	db.save(key, role, security)

If you were to add the @NamedParams method here, you would not be able to call it as an extension with the closure.

What you want is to “pin” the first parameter to the method. You can do this with the @Pin annotation.

	@NamedParams
	def static save(@Pin Database db, String key, Role role, Security security) { … }

Now you can use it like an extension:

	db.save [ key = … role = … security = …	]

## Option Programming

	import static extension nl.kii.util.OptExtensions.*
	import static extension nl.kii.util.*

A problem in Java is catching NullPointerExceptions. You end up with a lot of NullPointerException checks, or with code that throws one while your program runs. Languages like Scala use the idea of an Option to solve this. It forces you to catch these errors at compile time. By marking something an Opt<T> instead of a T, you are saying that the result is optional, and that the programmer should handle the case of no result.

The interface of Opt<T> is very simple:

https://github.com/blueneogeo/xtend-tools/blob/master/src/main/java/nl/kii/util/Opt.xtend

#### Opt, Some, None, Err

An Opt<T> can be a Some<T>, None<T> or Err<T>. If it is a Some, you can use the value method to get the value. The option extensions let you create an option from a value really easily. For example:

	import static extension nl.kii.util.OptExtensions.*
	…
	val o = new Some(12)
	o.value == 12 // true

	some(12).value == 12 // extension shortcut
	12.option.value == 12 // extension shortcut

#### .option and .or Extensions

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

#### Attempt

With attempt, you can catch errors, much like when you perform a try/catch. However the difference is that attempt will not throw an Exception, but instead will return an Err, None or Some(value), depending on what happened when executing the passed function.

	val Opt<User> user = attempt [ findUser(id) ]

#### Conditional Processing

To perform conditional processing (user is an Opt<User>):

	ifSome(user) [ ..do something with the user.. ]

#### Optional Mapping

To map a value that may not exist:

	val Opt<Integer> age = user.mapOpt [ it.age ] // user is an  Opt<User>

This is just a selection. For more extensions, check the source of OptExtensions.xtend:

https://github.com/blueneogeo/xtend-tools/blob/master/src/main/java/nl/kii/util/OptExtensions.xtend

## Easy Date Manipulating

	import static extension nl.kii.util.DateExtensions.*

Date manipulation becomes very natural with these extensions, since they overload the common operators + - < <= > and =>. Some code examples:

	// does what it says:
	println(now + 4.mins + 2.secs)

	// easily calculate moments and periods
	val Date yesterday = now - 24.hours
	val Date tomorrow = now + 1.days
	val Date in1Hour = now + 1.hour
	val Period oneHour30Minutes = 1.hour + 30.mins

	// calculate newest and oldest between values
	println(newest(tomorrow, in1Hour, yesterday)) // prints the value of tomorrow
	println(oldest(tomorrow, in1Hour)) // prints the value of in1Hour

	println((now - yesterday).days) // prints 1
	println(now > yesterday) // prints true
	println(2.mins.secs) // prints 120
	
## List Operations

	import static extension nl.kii.util.IterableExtensions.*

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

See for more operations IterableExtensions.xtend:

https://github.com/blueneogeo/xtend-tools/blob/master/src/main/java/nl/kii/util/IterableExtensions.xtend

#### List Operator Overloading

You can perform each with an overload:

	users.each [ … ]

You can also add to a list with an overload:

	list.add(3)
	list.add(5)
	list << 3 << 5 // almost the same thing

What is different is that the overload either calls List.add or IteratorExtensions.safeAdd, depending on whether the list is immutable. If it is immutable, it will perform an immutable add.

This means that if your list is immutable, you have to catch the result:

	// Integer.string creates an immutable list
	val list = Integer.string
	val list2 = list << 2 << 5 // catch result in list2

Often you can also reverse the direction. For example, this has the same result:

	2 >> list // results in a longer list
	list << 2 // same
	
	list >> [ println(it) ] // print each item in the list
	[ println(it) ] << list // same

## Logging

	import static extension nl.kii.util.LogExtensions.*
	import static extension org.slf4j.LoggerFactory.*
	import nl.kii.util.Log

You can use the logging wrapper like this:

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

#### Logger Naming

You can also add a name to the logger when you create it:

	extension Log logger = class.logger.wrapper('somename')

When you do this, this message will be put in front of every log statement made by this logger. This can be handy when you want to distinguish easily between types of messages in your log.

#### Logging List Results

Sometimes you have a list of things that you want to log. A common pattern is to do something like:

	api.getUsers(condition).each [
		val user = it
		info ['found user ' + user ]
		.. perform more code ..
	]

This pollutes your code with side effects (logging). A better alternative would be:

	api.getUsers(condition)
		.each [
			val user = it
			info ['found user ' + user ]
		]
		.each [
			.. perform more code ..
		]

Since this is a common pattern, here is a shortcut:

	api.getUsers(condition)
		.info(logger)
		.each [ .. perform more code .. ]

Optionally, you can also pass a logging message:
	api.getUsers(condition)
		.info('found users:', logger)
		.each [ .. perform more code .. ]

#### Logger Functions

You can also log like this:

	api.getUsers(condition)
		.each(info)
		.each [ .. perform some code .. ]

Here, info actually is a function that produces a function that gets called by each. It looks cleaner with the operators described below:

	api.getUsers(condition) >> info >> [ .. perform some code .. ]

Here too, you can add a message:

	api.getUsers(condition) >> info('found user:') >> [ .. perform some code .. ]	

Note that in this case, the message is put in front of every user.

Note: the logger functions only work if you have the "extension Log logger = class.logger.wrapper" line in your class.

#### Printing

If you don't want to log but just want to print, You can perform the same thing as above with printEach, which just prints all in the list, and returns the list, so you can keep processing the flow.

	// via list extension method
	#['Jane', 'Mark'].printEach
	#['Jane', 'Mark'].printEach('celebrities:')

	// via printEach lambda
	#['Jane', 'Mark'] >> printEach
	#['Jane', 'Mark'] >> printEach('celebrities:')

	// chaining example
	#[1, 2, 3] 
	>> printEach('inputs')
	>> [ it * 2 ]
	>> printEach('doubled')
