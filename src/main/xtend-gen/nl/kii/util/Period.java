package nl.kii.util;

import org.eclipse.xtend2.lib.StringConcatenation;

@SuppressWarnings("all")
public class Period {
  private final long time;
  
  public Period(final long time) {
    this.time = time;
  }
  
  public long time() {
    return this.time;
  }
  
  public long ms() {
    return this.time;
  }
  
  public long secs() {
    return (this.time / 1000);
  }
  
  public long mins() {
    return ((this.time / 1000) / 60);
  }
  
  public long hours() {
    return (((this.time / 1000) / 60) / 60);
  }
  
  public long days() {
    return ((((this.time / 1000) / 60) / 60) / 24);
  }
  
  public long years() {
    return (((((this.time / 1000) / 60) / 60) / 24) / 356);
  }
  
  public String toString() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append(this.time, "");
    _builder.append(" milliseconds");
    return _builder.toString();
  }
  
  public boolean equals(final Object obj) {
    boolean _xifexpression = false;
    if ((obj instanceof Period)) {
      _xifexpression = (((Period)obj).time == this.time);
    } else {
      _xifexpression = false;
    }
    return _xifexpression;
  }
  
  public int hashCode() {
    Long _long = new Long(this.time);
    return _long.hashCode();
  }
}
