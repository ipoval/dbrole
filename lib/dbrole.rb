# frozen_string_literal: true

module DbRole
end

require_relative 'lib/dbrole/version'
require_relative 'lib/dbrole/railtie' if defined?(Rails::Railtie)
