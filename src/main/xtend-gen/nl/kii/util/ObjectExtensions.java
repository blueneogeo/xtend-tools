package nl.kii.util;

import java.io.Serializable;
import org.apache.commons.lang.SerializationUtils;

@SuppressWarnings("all")
public class ObjectExtensions {
  /**
   * Clone an object using serialization. warning, this means it can be very
   * slow compared to normal cloning. Benefit is that it will provide deep cloning
   */
  @SuppressWarnings("unchecked")
  public static <T extends Serializable> T cloneSerializable(final T object) {
    Object _clone = SerializationUtils.clone(Object.class);
    return ((T) _clone);
  }
}
