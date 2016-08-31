# dbrole
Multi-DB connection switching strategy for Rails ActiveRecord library

##### RE-INITIALIZE MULTI-DB CONNECTIONS IN THE FORKED PROCESSES CONTEXT
```ruby
class ApplicationForkConfigurator
  def self.before_fork
    if defined?(ActiveRecord::Base)
      ActiveRecord::Base.connection_handler.clear_all_connections!
    end
  end

  def self.after_fork
    if defined?(ActiveRecord::Base)
      ActiveRecord::Base.establish_connection
      DbRole.hdb_roreplica_establish_connection
    end
  end
end
```

##### MANUAL CHECKS FOR MULTI-DB CONNECTIONS CONTEXT
```ruby
# number of connection pools (1 connection pool per DB replica)
ActiveRecord::Base.connection_handler.connection_pools.size
# connection secrets should be different from master connection
DbRole.hdb_roreplica.connection.instance_eval { @connection_parameters }
# check names of connection pools representing multi-db context
User.connection_handler.instance_eval { @class_to_pool }.keys # => ["ActiveRecord::Base", "ReadOnlyReplicaConnection"]
```

##### TODO
# CHECK THAT AFTER WE DROP THE CONNECTIONS FROM ALL THE POOLLS THE POOL TO THE READ-ONLY-REPLICA DB ALSO DOES NOT
# HAVE ANY OPEN CONNECTIONS
ActiveRecord::Base.connection_handler.connection_pools.to_a.last.last.connected?
