# frozen_string_literal: true

Maglev.configure do |config|
  # config.logo = 'logo.png'
  # config.favicon = 'favicon.ico'
  # config.primary_color = '#7362D0'
  # config.current_site = -> { current_user.maglev_site }
  config.uploader = :active_storage
end
