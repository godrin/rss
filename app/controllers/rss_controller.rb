require 'opml'

class RssController < ApplicationController
  before_filter :authenticate_user!, :except=>[:sign_up]
  before_filter :check_user
  layout 'main'

  def index
    redirect_to :action=>'single_site',:url=>@userEntity.url
  end

  def logout
    pp user_session.methods.sort
    redirect_to :action=>'index'
  end

  def unread
    url=params["url"]
    before=params["before"]

    e=Entity.find_by_url(url)
    if e
      e.unread_by!(@userEntity)
    end

    redirect_to :action=>'single_site',:url=>before
  end

  def single_site
    url=params["url"]
    url||=@userEntity.url
    @site=Entity.find(:first,:conditions=>{:url=>url})

    @children=@site.children.sort{|a,b|a.time<=>b.time}.reverse
    @parents=@site.parents.sort{|a,b|a.time<=>b.time}.reverse
    @wasRead=@site.read_by?(@userEntity)
    @maxPerPage=10
    @page=params["page"].to_i
    @pages=(@children.length+@maxPerPage-1)/@maxPerPage
    @page=[0,@children.length/@maxPerPage,@page].sort[1]
    @children=@children[(@page*@maxPerPage)...((@page+1)*@maxPerPage)]
    @tags=Tag.find(:all)
    readFlag(@site)
  end

  def add_comment
    text=params["text"]
    url=params["url"]
    @site=Entity.find(:first,:conditions=>{:url=>url})
    if @site
    end
    comment=Comment.new()
    comment.name="Comment"
    comment.description=text
    comment.url=rand.to_s
    comment.author=@userEntity.name
    comment.save
    comment.parents<<@site

    redirect_to :action=>'single_site',:url=>url
  end

  def add_rss_url
    url=params[:url]
    puts "Trying to add #{url}"
    rss=RssHelper.rssFromUrl(url)

    puts "RSS:",rss
    if rss

      rssurl=rss.link

      feed=Feed.get_by_url(rssurl)
      feed.addSubscription(@userEntity)
    end

    redirect_to :action=>'index'
  end

  def upload_file
    file=params[:uploaded_file]

    opml = Opml.new(file.read)

    OpmlHelper.import(opml,@userEntity)

    redirect_to :action=>'index'
  end

  def value
    pp "PS:",params
    before=params["before"]
    site=Entity.find(:first,:conditions=>{:url=>params["url"]})
    if site
      site.value!(@userEntity,params["value"].to_f*100)
    else
      pp "SITE NOT FOUND"
    end
    redirect_to :action=>'single_site',:url=>before
  end

  def update
    feed=Feed.find(:first,:conditions=>{:url=>params[:url]})
    if feed
      feed.updateWebDelayed
    end
    redirect_to :action=>'single_site',:url=>params[:url]
  end

  def item
    urlrss=params[:urlrss]
    url=params[:url]
    @item=NewsItem.find(:first,:conditions=>{:urlrss=>urlrss,:url=>url})
  end

  def rss
    respond_to{|format|
      format.atom
    }
    @headers["Content-Type"] = "application/rss+xml"
  end

  private

  def check_user
    @userEntity=UserEntity.find_or_create(current_user.email)
    @navis={"Home"=>"single_site","Feeds"=>"feeds","History"=>"history"}
  end

  def readFlag(site)
    site.read_by!(@userEntity)
  end
end
