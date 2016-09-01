# frozen_string_literal: true

# Example of usage:
#  dbrole(Car, DbRole.hdb_roreplica) { Car.where(...) }
#
def dbrole(klass, dbrole, &block)
  fail ArgumentError, 'provide a block to swith connection there' unless block_given?
  fail ArgumentError, 'bad DB role class' unless dbrole.respond_to?(:connection)

  klass.force_dbrole = dbrole
  yield
ensure
  klass.force_dbrole = nil
end

class ActiveRecord::Base
  class_attribute :force_dbrole, instance_accessor: false
end

class ActiveRecord::ConnectionAdapters::ConnectionHandler
  alias_method :'original retrieve_connection', :retrieve_connection

  def retrieve_connection(klass)
    if klass.force_dbrole
      return send(:'original retrieve_connection', klass.force_dbrole)
    end
    send(:'original retrieve_connection', klass)
  end
end
