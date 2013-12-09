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
    Publisher<String> _publisher = new Publisher<String>();
    final Publisher<String> p = _publisher;
    final Procedure1<String> _function = new Procedure1<String>() {
        public void apply(final String it) {
          String _plus = ("got " + it);
          InputOutput.<String>println(_plus);
        }
      };
    p.onChange(_function);
    Subject<String,String> _stream = StreamExtensions.<String>stream(p);
    final Procedure1<String> _function_1 = new Procedure1<String>() {
        public void apply(final String it) {
          String _plus = ("stream also works, got " + it);
          InputOutput.<String>println(_plus);
        }
      };
    StreamExtensions.<String>each(_stream, _function_1);
    p.publishChange("hoi");
  }
}
