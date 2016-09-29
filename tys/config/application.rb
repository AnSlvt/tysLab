require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tys
  class Application < Rails::Application
    config.logger = Logger.new(STDOUT)
    config.active_record.raise_in_transactional_callbacks = true

    #Try loading a YAML file at `./config/env.[environment].yml`, if it exists
    # Kudos to Thomas Fuchs (http://mir.aculo.us) for the initial implementation
    def load_env_file(environment)
      path = Rails.root.join("config", "env.#{environment}.yml")
      return unless File.exist? path
      config = YAML.load(ERB.new(File.new(path).read).result)
      config.each { |key, value| ENV[key.to_s] = value.to_s }
    end

    # Now look for custom environment variables, stored in env.[environment].yml
    # For development, this file is not checked into source control, so feel
    # free to tweak for your local development setup. Any values defined here
    # overwrite the defaults in `env.yml`
    load_env_file(Rails.env)
  end
end
