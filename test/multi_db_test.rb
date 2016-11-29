require_relative 'test_helper'

class MultiDbTest < Minitest::Test
  def teardown
    DbRole.clear
  end

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
    cars_master_db_count = Car.count
    Car.create!(model: 'mercedes')

    DbRole.switch(Car, ShardA::Replica) {
      cars_replica_db_count = Car.count
      Car.create!(model: 'mercedes')
      assert_equal Car.count, cars_replica_db_count + 1
    }

    assert_equal Car.count, cars_master_db_count + 1
  end

  def test_shardA_nested_connections_switching_with_db_role_switch_to_method
    create_car_in_master 'kia_on_master_shard'

    # everything from ActiveRecord::Base goes to ShardA::Replica
    DbRole.switch_to(ActiveRecord::Base, ShardA::Replica)
    assert_equal({ "ActiveRecord::Base" => ShardA::Replica }, Thread.current[:dbrole])

    # should not see record on replica db since it was created only on master db
    refute Car.exists?(model: "kia_on_master_shard")

    # explicitly switch to master in the block to make sure we do see the record on master
    DbRole.switch(ActiveRecord::Base, ActiveRecord::Base) do
      assert Car.exists?(model: "kia_on_master_shard")
    end

    # make sure still don't see record on replica db since it was created only on master db
    refute Car.exists?(model: "kia_on_master_shard")
  end

  private

  def create_car_in_master(_model)
    Car.create!(model: _model)
  end
  alias_method :create_car_in_replica, :create_car_in_master
end
