module ShardB
  class Replica < ActiveRecord::Base
    establish_connection(adapter: "sqlite3", database: GemTestSetup.shardB_replica_file)
    self.abstract_class = true
  end

  Replica.connection.instance_eval do
    create_table :animals, force: true do |t|
      t.string :kind, null: false
    end

    add_index(:animals, :kind, unique: true)
  end
end
