# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'support/skincare_resume_helpers'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def stub_current_user(user, &block)
      ApplicationController.stub_any_instance :current_user, user, &block
    end

    def stub_session(session, &block)
      ApplicationController.stub_any_instance :session, session, &block
    end

    OmniAuth.config.test_mode = true

    def mock_google_auth(user)
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        info: {
          name: user.name,
          email: user.email
        }
      )
    end
  end
end
