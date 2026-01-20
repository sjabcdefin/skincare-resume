Rails.application.config.middleware.use OmniAuth::Builder do
  if ENV["KAMAL_BUILD"] == "true"
    provider :google_oauth2,
      "dummy",
      "dummy",
      prompt: 'select_account'
  else
    provider :google_oauth2,
      Rails.application.credentials.google[:client_id],
      Rails.application.credentials.google[:client_secret],
      prompt: 'select_account'
  end

end
OmniAuth.config.allowed_request_methods = %i[get]
