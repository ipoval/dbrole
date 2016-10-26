# frozen_string_literal: true

# Example of usage:
#   DbRole.switch(Car, DbRole.hdb_roreplica) { Car.where(...) }
#
# Example (proposal) for switch_many(klassType1, roleType1, klassType2, roleType2, &block)
#   - to switch many different types of DB to new connection pools at once
#   - could be useful to switch connections on per request scope.
#
module DbRole
  module_function

  # @params:
  #   klass - ActiveRecord::Base class we want switch connection for
  #   role  - ActiveRecord::Base connection pool we want to use for the klass
  def switch(klass, role, &_block)
    fail ArgumentError, 'provide a block to swith connection' unless block_given?
    fail ArgumentError, 'bad DB role class' unless role.respond_to?(:connection)

    Thread.current[:dbrole] ||= {}
    klass_name = klass.name
    previous_role = Thread.current[:dbrole][klass_name]
    Thread.current[:dbrole][klass_name] = role

    yield
  ensure
    if Thread.current[:dbrole]
      if previous_role
        Thread.current[:dbrole][klass_name] = previous_role
      else
        Thread.current[:dbrole].delete(klass_name)
      end
    end
  end
end
