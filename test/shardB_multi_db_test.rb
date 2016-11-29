require_relative 'test_helper'

class ShardBMultiDbTest < Minitest::Test
  def teardown
    DbRole.clear
  end

  def test_shardB_master_replica_switching
    animals_master_count = Animal.count
    create_animal_in_master 'tiger'

    DbRole.switch(Animal, ShardB::Replica) {
      animals_replica_count = Animal.count
      create_animal_in_replica 'tiger'
      assert_equal Animal.count, animals_replica_count + 1
    }

    assert_equal Animal.count, animals_master_count + 1
  end

  def test_shardB_nested_connections_switching
    animals_master_count = Animal.count
    create_animal_in_master 'zebra'

    # all models inherited from ShardB::Master will switch connection to replica
    DbRole.switch(ShardB::Master, ShardB::Replica) do
      assert_equal({ "ShardB::Master" => ShardB::Replica }, Thread.current[:dbrole])

      animals_replica_count = Animal.count
      create_animal_in_replica 'zebra'

      DbRole.switch(Animal, ShardB::Master) {
        assert_equal({ "ShardB::Master" => ShardB::Replica, "Animal" => ShardB::Master }, Thread.current[:dbrole])

        create_animal_in_master 'antilope'
      }

      assert_equal Animal.count, animals_replica_count + 1 # count in replica
    end

    assert_equal Animal.count, animals_master_count + 2
    assert_equal({}, Thread.current[:dbrole])
  end

  private

  def create_animal_in_master(_kind)
    Animal.create!(kind: _kind)
  end
  alias_method :create_animal_in_replica, :create_animal_in_master
end
