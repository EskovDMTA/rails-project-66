Sentry.init do |config|
  config.dsn = 'https://70d7e8944a1bbc220d4643c754997a4f@o4506157839286272.ingest.sentry.io/4506579877756928'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end
