# frozen_string_literal: true

module DbRole
  class Manager
    attr_accessor :lock

    def patch!
      ActiveRecord::ConnectionAdapters::ConnectionHandler.class_eval do
        alias_method :'original_retrieve_connection_pool', :retrieve_connection_pool

        def retrieve_connection_pool(klass)
          switch_to = if Thread.current.key?(:dbrole) && Thread.current[:dbrole][klass.name]
            Thread.current[:dbrole][klass.name]
          else
            klass
          end

          send(:'original_retrieve_connection_pool', switch_to)
        end
      end
    end

  end
end

require_relative './dbrole/version'
require_relative './dbrole/railtie' if defined?(Rails::Railtie)
