class Animal < ShardB::Master
  validates_uniqueness_of :kind
end
