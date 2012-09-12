class Tag<Entity
  def self.get_by_name(name)
    t=Tag.find_by_name(name)
    unless t
      t=Tag.new({:name=>name})
      t.save
    end
    unless t
      t=Tag.find_by_name(name)
    end
    t
  end
end