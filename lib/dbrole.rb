# frozen_string_literal: true

module DbRole
end

require_relative './dbrole/version'
require_relative './dbrole/railtie' if defined?(Rails::Railtie)
