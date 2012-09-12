#require 'simple-rss'
require 'rss'
require 'open-uri'
require 'pp'
require 'hpricot'

module RssHelper
  def self.rssFromUrl(url)
    source=url
    content = ""
    open(source) do |s| content = s.read end
    rss=nil
    begin
      rss = RSS::Parser.parse(content,false)
    rescue SimpleRSSError
    rescue RSS::NotWellFormedError
    end

    if rss.nil?
      # retry - maybe this way html ??
      pp "OLD SOURCE #{source}"
      sources=urlsFromHtml(content)
      sources.each{|source|
        pp "NEW SOURCE #{source}"
        content = ""
        begin
          open(source) do |s| content = s.read end
          begin
            rss = RSS::Parser.parse(content)
          rescue SimpleRSSError
          rescue RSS::NotWellFormedError
          rescue RSS::NSError
          end
          #return rss if rss
        rescue OpenURI::HTTPError
        end
      }
    end
    $rss_counter||=0
    $rss_counter+=1
    #File.open("/tmp/rss#{$rss_counter}.xml","w"){|f|
    #  f.puts content
    #}
    rss
  end

  class MArray<Array
    def output(*args)
      map{|x|x.output(*args)}.join("")
    end

    def to_html(*args)
      map{|x|x.to_html(*args)}.join("")
    end
  end

  ALLOWED_ELEMENTS=["a","td","tr","p","table","div","pre","br","ul","ol","li","img","h1","h2","h3"]
  DISCARD_ELEMENTS=["iframe"]

  def self.recurse(doc,baseUrl)
    return doc if doc.is_a?(Hpricot::Text)
    return MArray.new([]) if DISCARD_ELEMENTS.member?(doc.name)
    if doc.children
      doc.children=doc.children.map{|element|
        recurse(element,baseUrl)
      }
    end

    checkAttributes(doc,baseUrl)

    allowed=true
    unless ALLOWED_ELEMENTS.member?(doc.name)
      allowed=false
    end
    if allowed
      doc
    else
      if  doc.children
        return MArray.new(doc.children)
      else
        return MArray.new([])
      end
    end

  end

  def self.checkAttributes(node,baseUrl)
    return unless node.respond_to?(:attributes)
    node.attributes.to_hash.each{|k,v|
      ok=true
      if k=="href"
        ok=(v=~/^http:\/\/.*$/)
      elsif k=="src"
        unless v=~/^http:\/\//
          if v=~/^\/.*$/
            protocol,dummy,host,*rest=baseUrl.split("/")
            baseUrl=protocol+"//"+host
          end
          #pp node.methods.sort
          node.set_attribute(k,baseUrl+"/"+v)
        end
      elsif k=~/^on.*$/
        ok=false
      end
      node.remove_attribute(k) unless ok
    }
    nil
  end

  def self.secureInnerHtml(content,baseUrl)
    return "" if content.nil?
    begin
      doc=Hpricot.parse(content, :xhtml_strict => true,:fixup_tags => true)
      doc=Hpricot.parse(doc.to_html, :xhtml_strict => true,:fixup_tags => true)
      doc=recurse(doc,baseUrl)

      doc.to_html
    rescue ArgumentError
      "INVALID HTML #{content.inspect}"
    end
  end

  def self.urlsFromHtml(content)
    doc = Hpricot.parse(content)
    types=["application/rss+xml","application/atom+xml","text/xml"]

    rssurls=[]
    types.each{|type|
      (doc/"link[@type='#{type}']").each do |link|
        rssurls << link["href"]
      end
    }
    pp "URL:",rssurls

    rssurls
  end
end
