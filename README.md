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
