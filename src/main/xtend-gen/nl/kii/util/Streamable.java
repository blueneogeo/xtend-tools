package nl.kii.util;

import rx.Observable;

@SuppressWarnings("all")
public interface Streamable<T extends Object> {
  public abstract Observable<T> stream();
}
