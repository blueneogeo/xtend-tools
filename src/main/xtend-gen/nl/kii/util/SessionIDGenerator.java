package nl.kii.util;

import java.util.UUID;

/**
 * got collisions when using the old version, now using official Java random ids to see if that fixes the issue.
 */
@SuppressWarnings("all")
public class SessionIDGenerator {
  public String nextSessionId() {
    UUID _randomUUID = UUID.randomUUID();
    return _randomUUID.toString();
  }
}
