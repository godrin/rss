require 'pp'
class CheckAllJob
  def perform
    pp "RUN..."
    Feed.find(:all).each{|feed|
      pp feed.url
      Delayed::Job.enqueue FeedCheckJob.new(feed.url)
    }
    CheckAllJob.setup
  end
  
  def self.setup
    x=Delayed::Job.find(:first,:conditions=>{:name=>self.name})
    if x
      pp "found job"
      pp x.methods.sort
    else
      Delayed::Job.enqueue CheckAllJob.new
      pp "enqueue CheckAllJob"
    end
  end
end