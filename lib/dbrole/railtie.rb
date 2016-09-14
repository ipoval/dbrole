module DbRole
  class Railtie < ::Rails::Railtie
    initializer "dbrole.initializer" do |app|
      if defined?(ActiveRecord::Base)
        require_relative "api"

        ::DbRoleManager = DbRole::Manager.new
        ::DbRoleManager.patch! if ENV["DBROLE_ENABLED"].present?
      else
        fail LoadError, "ActiveRecord::Base must be loaded"
      end
    end
  end
end
