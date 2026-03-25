# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include SkincareResumeHelpers
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def login(user)
    mock_google_auth user
    visit root_path
    assert_selector 'h1', text: 'トップページ'

    click_on 'Google アカウントでログイン'
    assert_selector 'h1', text: 'トップページ'
  end
end
