require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module TryHard59
  class Application < Rails::Application
    config.i18n.default_locale = :en
  end
end
