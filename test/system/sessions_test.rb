# frozen_string_literal: true

require 'application_system_test_case'

class SessionsTest < ApplicationSystemTestCase
  test 'user can log in and log out' do
    login users(:alice)

    accept_confirm 'ログアウトしますか？' do
      click_on 'ログアウト'
    end
    assert_current_path root_path
    assert_text 'Google アカウントでログイン'
  end
end
