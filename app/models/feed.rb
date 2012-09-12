require 'simple-rss'
require 'open-uri'
require 'pp'
require 'hpricot'
require 'application_helper'

class Feed < Site
  validates_presence_of :url
  validates_presence_of :urlrss
  
  MAX_CHILDREN = 100
  alias :newsItems :children
  def initialize(*args)
    super
    self.state="pending"
  end

  def updateWeb
    rss=RssHelper.rssFromUrl(self.url)
    retrieve(rss)
  end

  def imageName
    "rss.png"
  end
  
  def read_by?(userEntity)
    super(userEntity) and children.select{|item|not item.read_by?(userEntity)}.length==0
  end

  def unreadNewsItems(by)
    newsItems.select{|item|not item.read_by?(by)}
  end

  def updateWebDelayed
    Delayed::Job.enqueue(SiteUpdate.new(self.id))
  end
  
  def self.get_by_url(url)
    f=Feed.find_by_url(url)
    unless f
      f=Feed.new
      f.url=url
      f.urlrss=url
      f.save
    end
    assert{f}
    f
  end

  # not private, so creation is faster
  def retrieve(rss)

    #pp rss
    if rss.is_a?(RSS::Rss)
      channel=rss.channel

      self.name=channel.title
      self.description=channel.description

      self.state="retrieving"
      self.save
      children=0
      rss.items.each{|item|
        updateOrCreate(item)
        children+=1
        break if children>MAX_CHILDREN
      }

    else

      self.name=rss.title
      self.description=rss.subtitle if rss.respond_to?(:subtitle)

      self.state="retrieving"
      children=0
      rss.items.each{|item|
        updateOrCreate(item)
        children+=1
        break if children>MAX_CHILDREN
      }
    end
    self.state="retrieved"
    save
  end

  def save
    isnew=(self.id.nil?)
    super
    pp "new NewsItem"
    if isnew
      addJob
      pp" new update job"
    end
  end

  def addJob
    Delayed::Job.enqueue SiteUpdate.new(self.id)
  end

  private

  def updateOrCreate(item)
    news=NewsItem.find(:first,:conditions=>{:urlrss=>url,:url=>item.link})
    newlyCreated=false
    unless news
      news=NewsItem.new
      newlyCreated=true
    end
    news.urlrss=url
    news.url=item.link

    desc=""

    if item.content_encoded
      desc=item.content_encoded
    elsif item.description
      desc=item.description
    elsif item.respond_to?(:content)
      desc=item.content
    end

    news.description=desc
    if item.respond_to?(:updated)
      news.publication=item.updated
    elsif item.respond_to?(:pubDate)
      news.publication=item.pubDate.to_s
    elsif item.respond_to?(:date)
      news.publication=item.date
    end
    news.name=item.title

    news.save
    begin
      pp "Adding child...."
      self.children<<news
      pp "Added child."
      pp self.children
      pp "====="
      #news.parents<<self if newlyCreated
    rescue Object=>e
      pp e
    end
    pp news.name
    pp "FEEDID ",self.id
    pp "TAGS:"
    item.categories.each{|cat|
      news.tag_with(cat.content)
    }
    news
  end

end
