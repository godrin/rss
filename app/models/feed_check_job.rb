class FeedCheckJob < Struct.new(:url)
  def perform
    feed=Feed.find(:first,:conditions=>{:url=>self.url})
    if feed
      feed.updateFromRSS
    end
  end
end