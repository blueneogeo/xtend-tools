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