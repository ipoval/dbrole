# frozen_string_literal: true

# Example of usage:
#   DbRole.switch(Car, DbRole.hdb_roreplica) { Car.where(...) }
#
# Example (proposal) for switch_many(klassType1, roleType1, klassType2, roleType2, &block)
#   - to switch many different types of DB to new connection pools at once
#   - could be useful to switch connections on per request scope.
#
module DbRole
  # @params:
  #   klass - ActiveRecord::Base class we want switch connection for
  #   role  - ActiveRecord::Base connection pool we want to use for the klass
  def switch(klass, role, &_block)
    validate_role_and_klass(klass, role)
    klass_name = klass.name

    Thread.current[:dbrole] ||= {}
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
  module_function :switch

  # This method does not clear the connection key, so we need use DbRole.clear after
  #
  # @params:
  #   klass - ActiveRecord::Base class we want switch connection for
  #   role  - ActiveRecord::Base connection pool we want to use for the klass
  #
  def switch_to(klass, role)
    validate_role_and_klass(klass, role)
    klass_name = klass.name

    Thread.current[:dbrole] ||= {}
    Thread.current[:dbrole][klass_name] = role
  end
  module_function :switch_to

  # clear option to switch connection for any class name
  # it can be executed after a web-request
  def clear
    Thread.current[:dbrole].clear if Thread.current[:dbrole]
  end
  module_function :clear

  def validate_role_and_klass(klass, role)
    fail ArgumentError, 'bad DB class' unless klass.respond_to?(:connection)
    fail ArgumentError, 'bad DB role class' unless role.respond_to?(:connection)
  end
  module_function :validate_role_and_klass
end
