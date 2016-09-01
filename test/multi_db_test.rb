require_relative 'test_helper'
require_relative 'cases/db_master_setup'
require_relative 'cases/db_hdb_roreplica_setup'
require_relative 'cases/car'

class MultiDbTest < ActiveSupport::TestCase
  test 'master-db INSERT' do
    Car.destroy_all
    Car.create!(model: 'bmw')

    assert_equal 1, Car.count
    assert_equal 'bmw', Car.last.model
  end

  test 'replica-db INSERT' do
    dbrole(Car, TestDbRole::HdbRoReplica) do
      Car.destroy_all
      Car.create!(model: 'audi')

      assert_equal 1, Car.count
      assert_equal 'audi', Car.last.model
    end
  end

  test 'given UNIQUE INDEX on `cars.model` multi-db INSERT works' do
    assert_difference('Car.count', 1) do
      Car.create!(model: 'mercedes')

      dbrole(Car, TestDbRole::HdbRoReplica) {
        assert_difference('Car.count', 1) { Car.create!(model: 'mercedes') }
      }
    end

    assert_equal 1, Car.count
    dbrole(Car, TestDbRole::HdbRoReplica) do
      assert_equal 1, Car.count
    end
  end
end
