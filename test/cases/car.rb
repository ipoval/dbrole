class Car < ActiveRecord::Base
  validates_uniqueness_of :model
end
