require_relative 'test_helper'

class DbRoleApiTest < Minitest::Test
  def setup
    @connection_pool = MiniTest::Mock.new
    @switch_from = Struct.new(:connection, :name).new(ActiveRecord::Base, 'ActiveRecord::Base')
  end

  def test_db_role_should_accept_a_block
    @connection_pool.expect :connection, true

    assert_raises(ArgumentError, 'provide a block to swith connection') {
      DbRole.switch(Object, @connection_pool)
    }
  end

  def test_db_role_should_accept_klass_with_connection
    klass_without_connection = Class.new
    refute klass_without_connection.respond_to?(:connection)

    assert_raises(ArgumentError, 'bad DB role class') {
      DbRole.switch(Object, klass_without_connection) { true }
    }
  end

  def test_db_role_set_current_thread_state
    def @connection_pool.connection; end

    DbRole.switch(@switch_from, @connection_pool) do
      assert_equal @switch_from.name, Thread.current[:dbrole].keys.first
      assert_equal @connection_pool.object_id, Thread.current[:dbrole].values.first.object_id
    end
  end

  def test_db_role_clear
    Thread.current[:dbrole] ||= {}
    Thread.current[:dbrole]["Car"] = ShardA::Replica
    refute_empty Thread.current[:dbrole]

    DbRole.clear

    assert_empty Thread.current[:dbrole]
  end
end
