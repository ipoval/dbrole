module ShardA
  class Replica < ActiveRecord::Base
    establish_connection(adapter: "sqlite3", database: ":memory:", mode: "readonly")
    self.abstract_class = true
  end

  Replica.connection.instance_eval do
    create_table :cars, force: true do |t|
      t.string :model, null: false
    end

    add_index(:cars, :model, unique: true)
  end
end
