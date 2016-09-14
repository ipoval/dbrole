require_relative 'test_helper'
require_relative 'cases/db_master_setup'
require_relative 'cases/db_replica_setup'
require_relative 'cases/car'

class MultiDbTest < Minitest::Test
  def test_connection_pool_size
    # 1 connection pool for master db + 1 connection pool for replica db
    assert_equal 2, ActiveRecord::Base.connection_handler.connection_pools.size
  end

  def test_given_all_connections_cleared_connections_to_replica_db_should_also_be_cleared
    skip 'run this test alone'
    assert master_connection_pool.connected?
    assert replica_connection_pool.connected?

    ActiveRecord::Base.clear_all_connections!

    refute master_connection_pool.connected?
    refute replica_connection_pool.connected?
  end

  private

  def master_connection_pool
    ActiveRecord::Base.connection_handler.connection_pools.to_a[0][1]
  end

  def replica_connection_pool
    ActiveRecord::Base.connection_handler.connection_pools.to_a[1][1]
  end
end
