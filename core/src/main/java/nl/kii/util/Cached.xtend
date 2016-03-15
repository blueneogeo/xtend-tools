package nl.kii.util

import java.util.Date
import org.eclipse.xtext.xbase.lib.Functions.Function0

import static extension nl.kii.util.DateExtensions.*

/** A simple lightweight way to cache a single value */
class Cached<T> implements Function0<T> {

	val Period retainTime
	val =>T fetchFn
	
	var T data
	var Date lastFetched

	new(Period retainTime, =>T fetchFn)	{
		this.retainTime = retainTime
		this.fetchFn = fetchFn
	}
	
	def get() { apply }
	
	override T apply() {
		if(data == null || lastFetched == null || now - lastFetched > retainTime) {
			data = fetchFn.apply
			lastFetched = now
			data
		} else data
	}
	
}
