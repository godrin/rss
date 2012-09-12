class Site < Entity
  def initialize(*args)
    super
  end

  def updateWeb
  end


  def addSubscription(userEntity)
    Subscription.subscribe!(self, userEntity)
  end

end
