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

  test 'connection pool size' do
    # 1 connection pool for master db + 1 connection pool for replica db
    assert_equal 2, ActiveRecord::Base.connection_handler.connection_pools.size
  end

  # Commented out this test since it breaks connection switching

  # test 'given all connections cleared, connections to replica db should also be cleared' do
  #   assert master_connection_pool.connected?
  #   assert replica_connection_pool.connected?
  #
  #   ActiveRecord::Base.clear_all_connections!
  #
  #   refute master_connection_pool.connected?
  #   refute replica_connection_pool.connected?
  # end

  private

  def reestablish_connections_once
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    TestDbRole::HdbRoReplica.establish_connection(adapter: "sqlite3", database: ":memory:")
  end

  def master_connection_pool
    ActiveRecord::Base.connection_handler.connection_pools.to_a[0][1]
  end

  def replica_connection_pool
    ActiveRecord::Base.connection_handler.connection_pools.to_a[1][1]
  end
end
