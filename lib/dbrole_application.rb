# Example of usage:
#   DbRole.hdb_roreplica.connection.select_rows('SQL');
#
module DbRole
  # Abstract class that points to Hdb Readonly Replica DB connection pool
  class HdbRoReplica < ActiveRecord::Base
    establish_connection :readonly_replica
    self.abstract_class = true
  end

  module_function

  def hdb_roreplica_establish_connection
    HdbRoReplica.class_eval { establish_connection :readonly_replica }
  end

  def hdb_roreplica
    return ActiveRecord::Base if Rails.env.test?
    HdbRoReplica
  end
end
