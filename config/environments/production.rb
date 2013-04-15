AssetsContainer::Application.configure do

  config.assets.digest = false
  config.assets.compress = true
  config.assets.js_compressor = :uglifier
  # Use only compiled assets
  config.assets.compile = false
  config.cache_classes = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end
