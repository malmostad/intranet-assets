require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "sprockets/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to test and production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development)))
end

module AssetsContainer
  class Application < Rails::Application
    config.time_zone = 'Stockholm'
    config.i18n.default_locale = :en
    I18n.config.enforce_available_locales = true
    config.encoding = "utf-8"
    config.filter_parameters += [:password]

    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.precompile += %w(
      *.png *.jpg *.jpeg *.gif *.eot *.svg *.ttf *.woff *.map
      malmo.js
      malmo_no_jquery.js
      malmo.css
      html5shiv-printshiv.js
      masthead_standalone.css
      masthead_standalone_non_rwd.css
      masthead_standalone.js
      masthead_standalone_non_rwd.js
      masthead_standalone_non_rwd_without_jquery.js
      masthead_standalone_without_jquery.js
      google_analytics.js
      legacy/ie9.css
      legacy/ie7.css
    )
  end
end

AssetsContainer::Application.config.secret_token = 'Not_used_in_this_app_but_required_by_rails'
AssetsContainer::Application.config.secret_key_base = 'Not_used_in_this_app_but_required_by_rails'
