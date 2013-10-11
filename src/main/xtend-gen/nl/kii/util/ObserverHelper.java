package nl.kii.util;

import org.eclipse.xtext.xbase.lib.Procedures.Procedure0;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import rx.Observer;

@SuppressWarnings("all")
public class ObserverHelper<T extends Object> implements Observer<T> {
  private final Procedure1<? super T> onNext;
  
  private final Procedure1<? super Throwable> onError;
  
  private final Procedure0 onCompleted;
  
  public ObserverHelper(final Procedure1<? super T> onNext, final Procedure1<? super Throwable> onError, final Procedure0 onCompleted) {
    this.onNext = onNext;
    this.onError = onError;
    this.onCompleted = onCompleted;
  }
  
  public void onCompleted() {
    this.onCompleted.apply();
  }
  
  public void onError(final Throwable e) {
    this.onError.apply(e);
  }
  
  public void onNext(final T v) {
    this.onNext.apply(v);
  }
}
