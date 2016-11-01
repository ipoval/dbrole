require_relative 'test_helper'

class MultiDbTest < Minitest::Test
  def test_connection_pool_size
    # 2 connection pools for shardA (master, replica)
    # 2 connection pools for shardB (master, replica)
    assert_equal 4, ActiveRecord::Base.connection_handler.connection_pools.size
  end

  def test_given_all_connections_cleared_connections_to_replica_db_should_also_be_cleared
    skip 'only works for sqlite persisted to file'

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
