require_relative 'cases/car'

class MultiDBTest < ActiveSupport::TestCase
  test 'master DB' do
    Car.create!(model: 'bmw')
    assert_equal 1, Car.count
    assert_equal 'bmw', Car.find(1).model
  end

  test 'replica DB' do
    Car.create!(model: 'audi')
    assert_equal 1, Car.count
    assert_equal 'audi', Car.find(1).model
  end
end
