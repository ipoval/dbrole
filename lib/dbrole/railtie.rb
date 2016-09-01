module DbRole
  class Railtie < ::Rails::Railtie
    initializer "dbrole.initializer" do |app|
      if defined?(ActiveRecord::Base)
        require_relative "api"
        require_relative "app"
      else
        fail Loaderror.new("ActiveRecord::Base must be loaded")
      end
    end
  end
end
