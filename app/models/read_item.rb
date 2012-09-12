class ReadItem < Assign
  #validates_uniqueness_of :parent_id, :scope=>[:child_id]
  #validates_uniqueness_of :child_id, :scope=>[:parent_id]
  def self.read!(target,by)
    check_signature([target,by],[Entity,Entity])
    begin
      ReadItem.create!({:parent=>by,:child=>target,:read=>true})
    rescue ActiveRecord::RecordInvalid
    end
  end

  def self.read?(target,by)
    ReadItem.find_all_by_parent_id_and_child_id_and_read(by,target,true).length>0
  end

  def self.unread_by!(target,by)
    #FIXME
    items=ReadItem.find_all_by_parent_id_and_child_id_and_read(by,target,true)
    items.each{|item|
      item.unread!
    }
  end

  def unread!
    self.read=false
    save
  end

end
