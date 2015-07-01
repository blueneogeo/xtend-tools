package nl.kii.util

import java.math.BigInteger
import java.security.SecureRandom
import static extension java.util.UUID.*

/** got collisions when using the old version, now using official Java random ids to see if that fixes the issue. */
class SessionIDGenerator {

	def String nextSessionId() {
		randomUUID.toString
	}

}

class RandomIDGenerator {

	val random = new SecureRandom

	def String nextSessionId() {
		new BigInteger(130, random).toString(32)
	}

}
