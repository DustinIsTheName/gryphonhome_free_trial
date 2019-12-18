require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GryphonhomeFreeTrial
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    ShopifyAPI::Base.api_version = ShopifyAPI::Meta.admin_versions.find(&:latest_supported).handle
    ShopifyAPI::Base.site = "https://#{ENV["SHOPIFY_API_KEY"]}:#{ENV["SHOPIFY_PASSWORD"]}@#{ENV["SHOPIFY_URL"]}/admin"
  end
end
