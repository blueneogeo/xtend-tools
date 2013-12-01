package nl.kii.listen;

import java.util.List;
import nl.kii.listen.Change;
import nl.kii.listen.ListenableList;
import nl.kii.listen.ListenableMap;
import nl.kii.rx.StreamExtensions;
import nl.kii.util.IterableExtensions;
import nl.kii.util.MapExtensions;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.Pair;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Test;
import rx.Observable;

@SuppressWarnings("all")
public class TestListenable {
  @Test
  public void testList() {
    ListenableList<String> _listenableList = new ListenableList<String>();
    final ListenableList<String> list = _listenableList;
    IterableExtensions.<String>operator_doubleLessThan(list, "hi");
    Observable<Change<Integer,String>> _stream = list.stream();
    final Procedure1<Change<Integer,String>> _function = new Procedure1<Change<Integer,String>>() {
        public void apply(final Change<Integer,String> it) {
          InputOutput.<Change<Integer,String>>println(it);
        }
      };
    StreamExtensions.<Change<Integer,String>>each(_stream, _function);
    List<String> _doubleLessThan = IterableExtensions.<String>operator_doubleLessThan(list, "welcome!");
    IterableExtensions.<String>operator_doubleLessThan(_doubleLessThan, "Christian");
    list.remove("Christian");
  }
  
  @Test
  public void testMap() {
    ListenableMap<String,String> _listenableMap = new ListenableMap<String,String>();
    final ListenableMap<String,String> map = _listenableMap;
    Observable<Change<String,String>> _stream = map.stream();
    final Procedure1<Change<String,String>> _function = new Procedure1<Change<String,String>>() {
        public void apply(final Change<String,String> it) {
          InputOutput.<Change<String,String>>println(it);
        }
      };
    StreamExtensions.<Change<String,String>>each(_stream, _function);
    Pair<String,String> _mappedTo = Pair.<String, String>of("hello", "world");
    MapExtensions.<String, String>operator_doubleLessThan(map, _mappedTo);
    Pair<String,String> _mappedTo_1 = Pair.<String, String>of("hello", "world 2");
    MapExtensions.<String, String>operator_doubleLessThan(map, _mappedTo_1);
    map.remove("hello");
  }
}
