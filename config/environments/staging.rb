AssetsContainer::Application.configure do
  config.eager_load = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  config.assets.digest = false
  config.assets.compress = true
  config.assets.js_compressor = :uglifier
  config.assets.compile = false

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr
end
