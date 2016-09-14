# frozen_string_literal: true

# @params:
#   klass - ActiveRecord::Base class we want switch connection for
#   role  - ActiveRecord::Base connection pool we want to use for the klass
#
# Example of usage:
#   dbrole(Car, DbRole.hdb_roreplica) { Car.where(...) }
#
# Nesting is not supported:
#   dbrole() { dbrole() {} }
#
def dbrole(klass, role, &_block)
  fail ArgumentError, 'provide a block to swith connection' unless block_given?
  fail ArgumentError, 'bad DB role class' unless role.respond_to?(:connection)

  Thread.current[:dbrole] ||= {}
  Thread.current[:dbrole][klass.to_s] = role

  yield
ensure
  Thread.current[:dbrole].clear
end
