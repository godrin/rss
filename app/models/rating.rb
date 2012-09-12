class Rating<Assign
  def self.rate!(child,parent,value)
    Rating.create!({:parent=>parent,:child=>child,:value=>value})
  end
end