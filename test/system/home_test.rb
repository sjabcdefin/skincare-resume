# frozen_string_literal: true

require 'application_system_test_case'

class HomeTest < ApplicationSystemTestCase
  test 'all user sees top page before login' do
    visit root_path

    assert_selector 'h1', text: 'トップページ'
    assert_text 'Google アカウントでログイン'
    assert_text 'ログインせずに履歴書を作成'
  end

  test 'logged in user without resume sees top page' do
    login users(:bob)

    assert_selector 'h1', text: 'トップページ'
    assert_selector 'h2', text: '履歴書を作成して、'
    assert_selector 'h2', text: '肌の情報を整理しましょう'
  end

  test 'logged in user with resume sees resume summary' do
    login users(:alice)

    assert_selector 'h1', text: 'トップページ'
    assert_selector 'h2', text: 'スキンケアの履歴書'
    assert_text '履歴書を編集する'
  end

  test 'guest user can access resume form from top page' do
    visit root_path

    assert_selector 'h1', text: 'トップページ'

    click_on 'ログインせずに履歴書を作成'
    assert_selector 'h1', text: '使用しているスキンケア製品'
  end
end
