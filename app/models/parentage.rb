class Parentage<Assign
  validates_uniqueness_of :parent_id, :scope=>[:child_id]
  validates_uniqueness_of :child_id, :scope=>[:parent_id]
end