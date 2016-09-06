# frozen_string_literal: true

module DbRole
  class Manager
    def patch!
      Thread.current[:dbrole] ||= {}

      ActiveRecord::ConnectionAdapters::ConnectionHandler.class_eval do
        alias_method :'original retrieve_connection', :retrieve_connection

        def retrieve_connection(klass)
          if Thread.current[:dbrole].present? && \
             switch_to = Thread.current[:dbrole][klass.to_s]
            return send(:'original retrieve_connection', switch_to)
          end

          send(:'original retrieve_connection', klass)
        end
      end
    end
  end
end

require_relative './dbrole/version'
require_relative './dbrole/railtie' if defined?(Rails::Railtie)
