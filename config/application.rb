require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module EsporteMestre
  class Application < Rails::Application
    config.load_defaults 7.1

    config.assets.paths << Gem.loaded_specs['bootstrap'].full_gem_path + '/assets/stylesheets'

    config.autoload_lib(ignore: %w(assets tasks))
  end
end
