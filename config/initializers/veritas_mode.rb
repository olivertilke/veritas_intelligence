# Set default mode to DEMO on app boot.
# This ensures the app always starts in demo mode (zero external API calls)
# until explicitly switched to live mode via the UI toggle.
Rails.application.config.after_initialize do
  VeritasMode.set!("demo") unless Rails.cache.read(VeritasMode::CACHE_KEY).present?
end
