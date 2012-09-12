class Assign < ActiveRecord::Base

  belongs_to :parent, :class_name=>'Entity'
  belongs_to :child, :class_name=>'Entity'

  def self.read(child,parent)
    subs=self.find(:first,:conditions=>{:child_id=>child.id,:parent_id=>parent.id})
    if subs
      subs.read=true
      subs.save
    end
  end

  protected

  def self.checkMap(map)
    r={}
    map.each{|k,v|
      if v.respond_to?(:id)
        r[(k.to_s+"_id").to_sym]=v.id
      else
        r[k]=v
      end
    }
    r
  end
end
