class HdbRoReplica < ActiveRecord::Base
  establish_connection(adapter: "sqlite3", database: ":memory:")
  self.abstract_class = true  
end

HdbRoReplica.connection.create_table :cars, force: true do |t|
  t.string :model
end
