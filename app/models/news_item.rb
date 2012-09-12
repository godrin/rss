class NewsItem < SiteItem
  alias :feed :site
  def imageName
    "rss_paper.png"
  end
  
end
