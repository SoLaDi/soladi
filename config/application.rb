require_relative 'boot'

require 'rails'

omitted = %w(
  action_cable/engine
  action_mailbox/engine
  action_text/engine
)

%w(
  active_storage/engine
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  rails/test_unit/railtie
  sprockets/railtie
).each do |dep|
  begin
    require dep
  rescue LoadError
  end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Soladi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Permitted locales available for the application
    I18n.available_locales = [:en, :de]

    # Set default locale to something other than :en
    I18n.default_locale = :de

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
