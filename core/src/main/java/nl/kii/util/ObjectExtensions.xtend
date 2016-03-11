package nl.kii.util

import java.io.Serializable
// import org.apache.commons.lang.SerializationUtils
import sun.reflect.generics.reflectiveObjects.NotImplementedException

class ObjectExtensions { 

	// CLONING
	
	/** 
	 * Clone an object using serialization. warning, this means it can be very
	 * slow compared to normal cloning. Benefit is that it will provide deep cloning
	 */
	@Deprecated // removed to remove unnecessary dependency
	@SuppressWarnings("unchecked")
	def static <T extends Serializable> T cloneSerializable(T object) {
		// SerializationUtils.clone(Object) as T
		throw new NotImplementedException
	}

}
