require_relative 'test_helper'

class MultiDbTest < Minitest::Test
  def test_master_db_insert
    Car.destroy_all
    Car.create!(model: 'bmw')

    assert_equal 1, Car.count
    assert_equal 'bmw', Car.last.model
  end

  def test_replica_db_insert
    DbRole.switch(Car, ShardA::Replica) do
      Car.destroy_all
      Car.create!(model: 'audi')

      assert_equal 1, Car.count
      assert_equal 'audi', Car.last.model
    end
  end

  def test_replica_db_with_active_record_base
    Car.destroy_all
    DbRole.switch(ActiveRecord::Base, ShardA::Replica) { Car.destroy_all }
    Car.create!(model: 'audi')
    DbRole.switch(ActiveRecord::Base, ShardA::Replica) { Car.create!(model: 'audi') }
    assert_equal 1, Car.count
    assert_equal 1, DbRole.switch(ActiveRecord::Base, ShardA::Replica) { Car.count }
  end

  def test_given_unique_index_on_cars_model_multi_db_insert_works
    cars_in_primary_db_count = Car.count
    Car.create!(model: 'mercedes')

    DbRole.switch(Car, ShardA::Replica) {
      cars_in_replica_db_count = Car.count
      Car.create!(model: 'mercedes')
      assert_equal Car.count, cars_in_replica_db_count + 1
    }

    assert_equal Car.count, cars_in_primary_db_count + 1
  end
end
