package nl.kii.listen

/**
 * Lets you register listeners that respond to an incoming event of type E
 */
interface Listenable<E> {
	
	def void onChange(Procedures.Procedure1<E> listener)
	
}