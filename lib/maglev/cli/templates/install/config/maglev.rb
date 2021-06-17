# frozen_string_literal: true

Maglev.configure do |config|
  # config.logo = 'logo.png'
  # config.favicon = 'favicon.ico'
  # config.primary_color = '#7362D0'
  config.uploader = :active_storage
end

Maglev::Pro.configure do |config|
  # config.current_site = -> { current_user.maglev_site }
end
