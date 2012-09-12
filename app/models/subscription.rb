require 'application_helper.rb'

class Subscription<Assign
  MAX_SUBSCRIPTION=100

  validates_uniqueness_of :parent_id, :scope=>[:child_id]
  validates_uniqueness_of :child_id, :scope=>[:parent_id]

  def self.subscribe!(target,by)
    check_signature([target,by],[Entity,Entity])
    begin
      Subscription.create!({:parent=>by,:child=>target})
    rescue ActiveRecord::RecordInvalid
    end
  end
  deprecated do
    def self.newSubscription!(map)
      checked=checkMap(map)
      if checked[:child_id]==checked[:parent_id]
        raise "Parent and child are the same: #{checked.inspect}"
      end
      subs=self.find(:first,:conditions=>checked)
      unless subs
        subs=self.create!(map)
      end
      subs.subscribe_threshold=MAX_SUBSCRIPTION
      subs.save
      subs
    end

  end

end