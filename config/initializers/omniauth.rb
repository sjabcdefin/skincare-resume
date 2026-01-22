Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development? || Rails.env.test?
    provider :google_oauth2,
      Rails.application.credentials.google[:client_id],
      Rails.application.credentials.google[:client_secret],
      prompt: 'select_account'
  elsif ENV["OMNIAUTH_CLIENT_ID"].present? && ENV["OMNIAUTH_CLIENT_SECRET"].present?
    provider :google_oauth2,
      ENV.fetch("OMNIAUTH_CLIENT_ID"),
      ENV.fetch("OMNIAUTH_CLIENT_SECRET"),
      prompt: 'select_account'
  else
    provider :google_oauth2, "dummy", "dummy", prompt: 'select_account'
  end
end
OmniAuth.config.allowed_request_methods = %i[get]
