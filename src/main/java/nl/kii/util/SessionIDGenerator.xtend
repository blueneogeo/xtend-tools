package nl.kii.util

import java.math.BigInteger
import java.security.SecureRandom

public final class SessionIDGenerator {

	val random = new SecureRandom

	def String nextSessionId() {
		new BigInteger(130, random).toString(32)
	}

}
