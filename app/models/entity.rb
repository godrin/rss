class Entity < ActiveRecord::Base

  Stats=Struct.new(:value,:count)

  has_many :parentAssigns, :foreign_key=>'parent_id',:class_name=>'Subscription',:dependent=>:destroy
  has_many :childrenAssigns, :foreign_key=>'child_id',:class_name=>'Subscription',:dependent=>:destroy
  has_many :parents, :through=>:childrenAssigns
  has_many :children, :through=>:parentAssigns

  has_many :readerAssigns, :foreign_key=>'readable_id',:class_name=>'ReadNewsItem',:dependent=>:destroy
  has_many :readableAssigns, :foreign_key=>'reader_id',:class_name=>'ReadNewsItem',:dependent=>:destroy

  has_many :readers, :through=>:readerAssigns
  has_many :readables, :through=>:readableAssigns
  def initialize(*args)
    super
    self.publication=Time.now
  end

  def time
    self.publication||self.updated_at
  end

  def shortDescription
    nu=""
    begin
      nu=Hpricot(description, :xhtml_strict => true).to_plain_text
    rescue
    end
    nu[0..50]+"..."
  end
  
  def value_for(userEntity)
    # FIXME
    valued_as
  end

  def valued_as
    vals=Assign.find(:all,:conditions=>{:child_id=>self.id}).map{|v|v.value}.select{|x|x}
    return Stats.new(0,0) if vals.length==0
    Stats.new(vals.average/100.0||0,vals.length||0)
  end

  def getSubscription(entity)
    Assign.find(:first,:conditions=>{:parent_id=>entity.id,:child_id=>self.id})
  end

  def read_by?(entity)
    ReadItem.read?(self,entity)
  end

  def unread_by!(entity)
    ReadItem.unread_by!(self,entity)
  end

  def findOrCreateSubscription(entity)
    addSubscription(entity) #{:child=>self,:parent=>entity})
  end

  def read_by!(user)
    ReadItem.read!(self,user)
  end

  def value!(user,value)
    Rating.rate!(self,user,value)
  end

  def tag_with(tagName)
    begin
      Tag.get_by_name(tagName).children<<self
    rescue ActiveRecord::RecordInvalid=>e
      pp e,e.backtrace
    end
  end

end
