require_relative 'test_helper'
require_relative 'cases/db_master_setup'
require_relative 'cases/db_hdb_roreplica_setup'

class MultiDbConnectionTest < ActiveSupport::TestCase
  test 'connection pool size' do
    # 1 connection pool for master db + 1 connection pool for replica db
    assert_equal 2, ActiveRecord::Base.connection_handler.connection_pools.size
  end

  test 'given all connections cleared, connections to replica db should also be cleared' do
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
