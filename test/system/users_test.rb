# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  test 'logged in user destroys account' do
    login users(:alice)

    accept_confirm '本当にアカウントを削除しますか？' do
      click_on 'アカウント削除'
    end

    assert_current_path root_path
    assert_text 'Google アカウントでログイン'
  end
end
