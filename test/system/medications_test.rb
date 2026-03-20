# frozen_string_literal: true

require 'application_system_test_case'

class MedicationsTest < ApplicationSystemTestCase
  test 'logged in user without resume sees medication form' do
    login users(:bob)

    visit medications_url
    assert_selector 'h1', text: '使用している薬'
    assert_selector '#new_medication'
  end

  test 'logged in user creates medication' do
    login users(:alice)

    visit medications_url
    find('#add-form-button').click
    assert_selector '#new_medication'

    create_medication(date: '002025/12/25', name: 'ベピオローション')
    assert_text '2025/12/25'
    assert_text 'ベピオローション'
  end

  test 'logged in user updates medication' do
    login users(:alice)

    visit medications_url
    medication = Medication.find_by!(name: 'ベピオゲル')
    find("##{dom_id(medication)}").click

    within "##{dom_id(medication)}" do
      fill_in '薬名', with: 'ベピオウォッシュゲル'
      click_on '更新する'
      assert_text 'ベピオウォッシュゲル'
    end
  end

  test 'logged in user destorys medication' do
    login users(:alice)

    visit medications_url
    medication = Medication.find_by!(name: 'ベピオゲル')
    find("##{dom_id(medication)}").click

    within "##{dom_id(medication)}" do
      accept_confirm '本当に削除しますか？' do
        find('#delete_button').click
      end
    end
    assert_no_selector "##{dom_id(medication)}"
  end

  test 'logged in user returns to top page' do
    login users(:alice)

    visit medications_url
    click_on 'トップページに戻る'

    assert_current_path root_path
    assert_selector '#medications-table'
  end

  test 'guest user without resume sees medication form' do
    visit medications_url
    assert_selector 'h1', text: '使用している薬'
    assert_selector '#new_medication'
  end

  test 'guest user creates medication' do
    visit medications_url

    create_medication(date: '002025/12/25', name: 'ベピオローション')
    assert_text '2025/12/25'
    assert_text 'ベピオローション'
  end

  test 'guest user updates medication' do
    visit medications_url

    create_medication(name: 'ベピオローション')
    assert_selector '#medications', text: 'ベピオローション'

    medication = Medication.find_by!(name: 'ベピオローション')
    find("##{dom_id(medication)}").click

    within "##{dom_id(medication)}" do
      fill_in '薬名', with: 'ベピオウォッシュゲル'
      click_on '更新する'
      assert_text 'ベピオウォッシュゲル'
    end
  end

  test 'guest user destorys medication' do
    visit medications_url

    create_medication(name: 'ベピオローション')
    assert_selector '#medications', text: 'ベピオローション'

    medication = Medication.find_by!(name: 'ベピオローション')
    find("##{dom_id(medication)}").click

    within "##{dom_id(medication)}" do
      accept_confirm '本当に削除しますか？' do
        find('#delete_button').click
      end
    end
    assert_no_selector "##{dom_id(medication)}"
  end

  test 'guest user returns to top page' do
    visit medications_url

    create_medication(name: 'ベピオローション')
    assert_selector '#medications', text: 'ベピオローション'

    click_on 'トップページに戻る'

    assert_current_path root_path
    assert_text 'Google アカウントでログイン'
    assert_text 'ログインせずに履歴書を作成'
  end

  test 'guest user saves skincare resume' do
    visit medications_url

    create_medication(date: '002025/12/25', name: 'ベピオローション')
    assert_selector '#medications', text: 'ベピオローション'

    click_on '保存する'

    assert_current_path root_path

    within '#medications-table' do
      row = find('tbody tr', text: 'ベピオローション')
      within row do
        assert_selector 'td:nth-child(1)', text: '2025/12/25'
        assert_selector 'td:nth-child(2)', text: 'ベピオローション'
      end
    end
  end
end
