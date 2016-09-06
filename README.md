# dbrole
Multi-DB connection switching strategy for Rails ActiveRecord library

[![Build Status](https://travis-ci.org/ipoval/dbrole.svg?branch=master)](https://travis-ci.org/ipoval/dbrole)
[![Code Climate](https://codeclimate.com/github/ipoval/dbrole/badges/gpa.svg)](https://codeclimate.com/github/ipoval/dbrole)

##### USAGE
```ruby
I. DbRole.hdb_roreplica.connection.select_rows('SQL'); # acquire active connection from replica connection pool

II. dbrole(Car, DbRole.hdb_roreplica) { Car.where(...) } # switch db connection pool for Car klass mapping

#**** Nesting is not supported ***#

dbrole(Car, DbRole.hdb_roreplica) {
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
      DbRole.hdb_roreplica_establish_connection
    end
  end
end
```

##### MANUAL CHECKS FOR MULTI-DB CONNECTION CONTEXT
```ruby
# number of connection pools (1 connection pool per DB replica)
ActiveRecord::Base.connection_handler.connection_pools.size
# connection secrets should be different from master connection
DbRole.hdb_roreplica.connection.instance_eval { @connection_parameters }
# check names of connection pools representing multi-db context
User.connection_handler.instance_eval { @class_to_pool }.keys # => ["ActiveRecord::Base", "HdbRoReplica"]
```

##### TESTS RUN
```
bundle exec rake
```
