module OpmlHelper
  def self.import(opml,userEntity)

    if opml.respond_to?(:attributes)
      attributes=opml.attributes
      xml=attributes["xml_url"]
      title=attributes["title"]
      text=attributes["text"]
      type=attributes["type"]
      html=attributes["html_url"]
      if xml=~/^http.*$/ and type=="rss"
        feed=Feed.find(:first,:conditions=>{:url=>xml})
        unless feed
          feed=Feed.new(:url=>xml,:name=>title,:description=>text)
          feed.save
        end
        feed.addSubscription(userEntity)
      end
    end

    if opml.respond_to?(:outlines)
      opml.outlines.each{|outline|
        import(outline,userEntity)
      }
    end
  end
end