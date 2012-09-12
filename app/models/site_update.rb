require 'pp'
require 'application_helper.rb'

class SiteUpdate
  NEXT_UPDATE=10.minutes #60*5 # 5 minutes
  
  attr_accessor :siteId
  def initialize(siteId)
    pp "new SiteUpdate-job"
    assert{not siteId.nil?}
    self.siteId=siteId
  end

  def perform
    begin
      pp self.siteId
      site=getSite
      pp site
      site.updateWeb
      Delayed::Job.enqueue(self,0,Time.now+NEXT_UPDATE)
    rescue Object=>e
      pp e,e.backtrace
      raise e
    end
  end

  def getSite
    Entity.find(:first,:conditions=>{:id=>self.siteId})
  end
end