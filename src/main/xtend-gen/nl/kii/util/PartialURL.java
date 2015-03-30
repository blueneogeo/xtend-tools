package nl.kii.util;

import com.google.common.base.Objects;
import java.net.MalformedURLException;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.eclipse.xtend.lib.annotations.Accessors;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ListExtensions;
import org.eclipse.xtext.xbase.lib.Pair;
import org.eclipse.xtext.xbase.lib.Pure;

/**
 * This URL implementation is more flexible than the standard Java URL, it allows for incomplete URLs
 * to be parsed and constructed. This is useful for matching these partial urls especially, or for
 * creating relative urls.
 */
@Accessors
@SuppressWarnings("all")
public class PartialURL {
  private final static Pattern pattern = Pattern.compile("^(?=[^&])(?:(?<scheme>[^:/?#]+):)?(?://(?<authority>[^/?#]*))?(?<path>[^?#]*)(?:\\?(?<query>[^#]*))?(?:#(?<fragment>.*))?");
  
  private final static Pattern validate = Pattern.compile("^(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]");
  
  private String protocol;
  
  private String domain;
  
  private String path;
  
  private String query;
  
  private String hash;
  
  public PartialURL(final String url) {
    try {
      final Matcher matcher = PartialURL.pattern.matcher(url);
      boolean _matches = matcher.matches();
      if (_matches) {
        String _group = matcher.group("scheme");
        this.protocol = _group;
        String _group_1 = matcher.group("authority");
        this.domain = _group_1;
        String _group_2 = matcher.group("path");
        this.path = _group_2;
        String _group_3 = matcher.group("query");
        this.query = _group_3;
        String _group_4 = matcher.group("fragment");
        this.hash = _group_4;
      } else {
        throw new MalformedURLException();
      }
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  /**
   * get a map of all the parameters passed in the url
   */
  public Map<String, String> getParameters() {
    String[] _split = null;
    if (this.query!=null) {
      _split=this.query.split("&");
    }
    List<String[]> _map = null;
    if (((List<String>)Conversions.doWrapArray(_split))!=null) {
      final Function1<String, String[]> _function = new Function1<String, String[]>() {
        @Override
        public String[] apply(final String it) {
          return it.split("=");
        }
      };
      _map=ListExtensions.<String, String[]>map(((List<String>)Conversions.doWrapArray(_split)), _function);
    }
    List<Pair<String, String>> _map_1 = null;
    if (_map!=null) {
      final Function1<String[], Pair<String, String>> _function_1 = new Function1<String[], Pair<String, String>>() {
        @Override
        public Pair<String, String> apply(final String[] it) {
          Pair<String, String> _xifexpression = null;
          int _length = it.length;
          boolean _equals = (_length == 2);
          if (_equals) {
            String _get = it[0];
            String _get_1 = it[1];
            _xifexpression = Pair.<String, String>of(_get, _get_1);
          }
          return _xifexpression;
        }
      };
      _map_1=ListExtensions.<String[], Pair<String, String>>map(_map, _function_1);
    }
    Iterable<Pair<String, String>> _filterNull = null;
    if (_map_1!=null) {
      _filterNull=IterableExtensions.<Pair<String, String>>filterNull(_map_1);
    }
    Map<String, String> _map_2 = null;
    if (_filterNull!=null) {
      _map_2=nl.kii.util.IterableExtensions.<String, String>toMap(_filterNull);
    }
    return _map_2;
  }
  
  /**
   * combination of protocol, domain and path
   */
  public String getFullPath() {
    return (((this.protocol + "://") + this.domain) + this.path);
  }
  
  /**
   * checks if the passed url is a valid url (adheres to standards)
   */
  public static boolean isValid(final String url) {
    Matcher _matcher = PartialURL.validate.matcher(url);
    return _matcher.matches();
  }
  
  /**
   * checks if the partial url is complete enough to be valid
   */
  public boolean isValid() {
    String _string = this.toString();
    Matcher _matcher = PartialURL.validate.matcher(_string);
    return _matcher.matches();
  }
  
  @Override
  public String toString() {
    StringConcatenation _builder = new StringConcatenation();
    {
      boolean _notEquals = (!Objects.equal(this.protocol, null));
      if (_notEquals) {
        _builder.append(this.protocol, "");
        _builder.append("://");
      }
    }
    {
      boolean _notEquals_1 = (!Objects.equal(this.domain, null));
      if (_notEquals_1) {
        _builder.append(this.domain, "");
      }
    }
    {
      boolean _notEquals_2 = (!Objects.equal(this.path, null));
      if (_notEquals_2) {
        _builder.append(this.path, "");
      }
    }
    {
      boolean _notEquals_3 = (!Objects.equal(this.query, null));
      if (_notEquals_3) {
        _builder.append("?");
        _builder.append(this.query, "");
      }
    }
    {
      boolean _notEquals_4 = (!Objects.equal(this.hash, null));
      if (_notEquals_4) {
        _builder.append("#");
        _builder.append(this.hash, "");
      }
    }
    return _builder.toString();
  }
  
  @Pure
  public String getProtocol() {
    return this.protocol;
  }
  
  public void setProtocol(final String protocol) {
    this.protocol = protocol;
  }
  
  @Pure
  public String getDomain() {
    return this.domain;
  }
  
  public void setDomain(final String domain) {
    this.domain = domain;
  }
  
  @Pure
  public String getPath() {
    return this.path;
  }
  
  public void setPath(final String path) {
    this.path = path;
  }
  
  @Pure
  public String getQuery() {
    return this.query;
  }
  
  public void setQuery(final String query) {
    this.query = query;
  }
  
  @Pure
  public String getHash() {
    return this.hash;
  }
  
  public void setHash(final String hash) {
    this.hash = hash;
  }
}
