AssetsContainer::Application.configure do
  config.cache_classes = true
  config.eager_load = true

  config.assets.digest = false
  config.assets.compress = true
  config.assets.js_compressor = :uglifier
  config.assets.compile = false

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end
