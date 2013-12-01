package nl.kii.listen

enum ChangeType {
	ADD, REMOVE, UPDATE, CLEAR
}

@Data
class Change<K, T> {

	val ChangeType change
	val T newValue
	val K position
	val int size
	
}
