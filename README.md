# dbrole
Multi-DB connection switching strategy for Rails ActiveRecord library

[![Build Status](https://travis-ci.org/ipoval/dbrole.svg?branch=master)](https://travis-ci.org/ipoval/dbrole)
[![Code Climate](https://codeclimate.com/github/ipoval/dbrole/badges/gpa.svg)](https://codeclimate.com/github/ipoval/dbrole)

##### SETUP IN RAILS APPLICATION
```
module DbRole
  # Abstract class that points to Read-Replica DB connection pool
  class ReadReplica < ActiveRecord::Base
    establish_connection :read_replica
    self.abstract_class = true
  end

  module_function

  def read_replica
    return ActiveRecord::Base if Rails.env.test?
    ReadReplica
  end
end
```

##### HOW TO ENABLE
```
DBROLE_ENABLED=true # environment variable when set triggers activation on rails environment boot
```

##### CONNECTIONS STORED IN CONNECTION POOLS MANAGED BY CONNECTION HANDLER
![alt text](../master/assets/ar-connections-diagram.png "")

##### USAGE
```ruby
I. DbRole.read_replica.connection.select_rows('SQL');   # acquire active connection from replica connection pool

II. dbrole(Car, DbRole.read_replica) { Car.where(...) } # switch db connection pool for Car klass mapping

#**** Nesting is not supported ***#

dbrole(Car, DbRole.read_replica) {
  Car.where(...)
  dbrole(Car, ActiveRecord::Base) { ... }
}

#**********************************#
```

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
      DbRole.read_replica_establish_connection
    end
  end
end
```

##### MANUAL CHECKS FOR MULTI-DB CONNECTION CONTEXT
```ruby
# number of connection pools (1 connection pool per DB replica)
ActiveRecord::Base.connection_handler.connection_pools.size

# connection secrets should be different from master connection
DbRole.read_replica.connection.instance_eval { @connection_parameters }

# check names of connection pools representing multi-db context
User.connection_handler.instance_eval { @class_to_pool }.keys # => ["ActiveRecord::Base", "ReadReplica"]
```

##### TESTS RUN
```
bundle exec rake
```
