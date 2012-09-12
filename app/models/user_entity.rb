class UserEntity<Entity
  def self.find_or_create(email)
    user=UserEntity.find(:first,:conditions=>{:name=>email})
    unless user
      user=UserEntity.new(:name=>email,:url=>email)
      user.save
    end
    user
  end
  def imageName
    "man.png"
  end
end