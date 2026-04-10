Rails.application.config.middleware.use OmniAuth::Builder do
  client_id = ENV["OMNIAUTH_CLIENT_ID"]
  client_secret = ENV["OMNIAUTH_CLIENT_SECRET"]

  if client_id.present? && client_secret.present?
    provider :google_oauth2, client_id, client_secret, prompt: 'select_account'
  else
    provider :google_oauth2, "dummy", "dummy", prompt: 'select_account'
  end
end
OmniAuth.config.allowed_request_methods = %i[post]
