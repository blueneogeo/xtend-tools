package nl.kii.listen;

import nl.kii.listen.Publisher;
import nl.kii.rx.StreamExtensions;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Test;
import rx.subjects.Subject;

@SuppressWarnings("all")
public class TestListenable {
  @Test
  public void testPublisher() {
    final Publisher<String> p = new Publisher<String>();
    final Procedure1<String> _function = new Procedure1<String>() {
      public void apply(final String it) {
        InputOutput.<String>println(("got " + it));
      }
    };
    p.onChange(_function);
    Subject<String, String> _stream = StreamExtensions.<String>stream(p);
    final Procedure1<String> _function_1 = new Procedure1<String>() {
      public void apply(final String it) {
        InputOutput.<String>println(("stream also works, got " + it));
      }
    };
    StreamExtensions.<String>each(_stream, _function_1);
    p.publish("hoi");
  }
}
