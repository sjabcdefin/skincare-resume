# frozen_string_literal: true

require 'application_system_test_case'

class TreatmentsTest < ApplicationSystemTestCase
  test 'logged in user without resume sees treatment form' do
    login users(:bob)

    visit treatments_url
    assert_selector 'h1', text: '治療履歴'
    assert_selector '#new_treatment'
  end

  test 'logged in user selects and creates treatment' do
    login users(:alice)

    visit treatments_url
    find('#add-form-button').click
    assert_selector '#new_treatment'

    create_treatment(date: '002025/12/25', name: 'ヤグレーザー')
    assert_text '2025/12/25'
    assert_text 'ヤグレーザー'
  end

  test 'logged in user updates treatment' do
    login users(:alice)

    visit treatments_url
    treatment = Treatment.find_by!(name: 'ミラノリピール')
    find("##{dom_id(treatment)}").click

    within "##{dom_id(treatment)}" do
      fill_in '治療名', with: 'イオン導入'
      click_on '更新する'
      assert_text 'イオン導入'
    end
  end

  test 'logged in user destorys treatment' do
    login users(:alice)

    visit treatments_url
    treatment = Treatment.find_by!(name: 'ミラノリピール')
    find("##{dom_id(treatment)}").click

    within "##{dom_id(treatment)}" do
      accept_confirm '本当に削除しますか？' do
        find('#delete_button').click
      end
    end
    assert_no_selector "##{dom_id(treatment)}"
  end

  test 'logged in user returns to top page' do
    login users(:alice)

    visit treatments_url
    click_on 'トップページに戻る'

    assert_current_path root_path
    assert_selector '#treatments-table'
  end

  test 'guest user without resume sees treatment form' do
    visit treatments_url
    assert_selector 'h1', text: '治療履歴'
    assert_selector '#new_treatment'
  end

  test 'guest user selects and creates treatment' do
    visit treatments_url

    create_treatment(date: '002025/12/25', name: 'ヤグレーザー')
    assert_text '2025/12/25'
    assert_text 'ヤグレーザー'
  end

  test 'guest user updates treatment' do
    visit treatments_url

    create_treatment(name: 'ヤグレーザー')
    assert_selector '#treatments', text: 'ヤグレーザー'

    treatment = Treatment.find_by!(name: 'ヤグレーザー')
    find("##{dom_id(treatment)}").click

    within "##{dom_id(treatment)}" do
      fill_in '治療名', with: 'イオン導入'
      click_on '更新する'
      assert_text 'イオン導入'
    end
  end

  test 'guest user destorys treatment' do
    visit treatments_url

    create_treatment(name: 'ヤグレーザー')
    assert_selector '#treatments', text: 'ヤグレーザー'

    treatment = Treatment.find_by!(name: 'ヤグレーザー')
    find("##{dom_id(treatment)}").click

    within "##{dom_id(treatment)}" do
      accept_confirm '本当に削除しますか？' do
        find('#delete_button').click
      end
    end
    assert_no_selector "##{dom_id(treatment)}"
  end

  test 'guest user returns to top page' do
    visit treatments_url

    create_treatment(name: 'ヤグレーザー')
    assert_selector '#treatments', text: 'ヤグレーザー'

    click_on 'トップページに戻る'

    assert_current_path root_path
    assert_text 'Google アカウントでログイン'
    assert_text 'ログインせずに履歴書を作成'
  end

  test 'guest user saves skincare resume' do
    visit treatments_url

    create_treatment(date: '002025/12/25', name: 'ヤグレーザー')
    assert_selector '#treatments', text: 'ヤグレーザー'

    click_on '保存する'

    assert_current_path root_path

    within '#treatments-table' do
      row = find('tbody tr', text: 'ヤグレーザー')
      within row do
        assert_selector 'td:nth-child(1)', text: '2025/12/25'
        assert_selector 'td:nth-child(2)', text: 'ヤグレーザー'
      end
    end
  end

  private

  def create_treatment(name:, date: nil)
    within '#new_treatment' do
      fill_in '治療日', with: date if date.present?
      fill_in '治療名', with: name
      click_on '登録する'
    end
  end
end
