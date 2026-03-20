# frozen_string_literal: true

require 'application_system_test_case'

class AllergiesTest < ApplicationSystemTestCase
  test 'logged in user without resume sees allergy form' do
    login users(:bob)

    visit allergies_url
    assert_selector 'h1', text: 'アレルギー歴'
    assert_selector '#new_allergy'
  end

  test 'logged in user selects and creates allergy' do
    login users(:alice)

    visit allergies_url
    find('#add-form-button').click
    assert_selector '#new_allergy'

    select_and_create_allergy(name: '金属(金)')
    assert_text '金属(金)'
  end

  test 'logged in user inputs and creates allergy' do
    login users(:alice)

    visit allergies_url
    find('#add-form-button').click
    assert_selector '#new_allergy'

    input_and_create_allergy(name: 'ピーナッツ')
    assert_text 'ピーナッツ'
  end

  test 'logged in user updates allergy' do
    login users(:alice)

    visit allergies_url
    allergy = Allergy.find_by!(name: '金属(亜鉛)')
    find("##{dom_id(allergy)}").click

    within "##{dom_id(allergy)}" do
      find('.ts-control').click
      find('.ts-dropdown-content .option', text: '花粉(ヒノキ)').click
      click_on '更新する'
      assert_text '花粉(ヒノキ)'
    end
  end

  test 'logged in user destorys allergy' do
    login users(:alice)

    visit allergies_url
    allergy = Allergy.find_by!(name: '金属(亜鉛)')
    find("##{dom_id(allergy)}").click

    within "##{dom_id(allergy)}" do
      accept_confirm '本当に削除しますか？' do
        find('#delete_button').click
      end
    end
    assert_no_selector "##{dom_id(allergy)}"
  end

  test 'logged in user returns to top page' do
    login users(:alice)

    visit allergies_url
    click_on 'トップページに戻る'

    assert_current_path root_path
    assert_selector '#allergies-table'
  end

  test 'guest user without resume sees allergy form' do
    visit allergies_url
    assert_selector 'h1', text: 'アレルギー歴'
    assert_selector '#new_allergy'
  end

  test 'guest user selects and creates allergy' do
    visit allergies_url

    select_and_create_allergy(name: '金属(金)')
    assert_text '金属(金)'
  end

  test 'guest user inputs and creates allergy' do
    visit allergies_url

    input_and_create_allergy(name: 'ピーナッツ')
    assert_text 'ピーナッツ'
  end

  test 'guest user updates allergy' do
    visit allergies_url

    select_and_create_allergy(name: '金属(金)')
    assert_selector '#allergies', text: '金属(金)'

    allergy = Allergy.find_by!(name: '金属(金)')
    find("##{dom_id(allergy)}").click

    within "##{dom_id(allergy)}" do
      find('.ts-control').click
      find('.ts-dropdown-content .option', text: '花粉(ヒノキ)').click
      click_on '更新する'
      assert_text '花粉(ヒノキ)'
    end
  end

  test 'guest user destorys allergy' do
    visit allergies_url

    select_and_create_allergy(name: '金属(金)')
    assert_selector '#allergies', text: '金属(金)'

    allergy = Allergy.find_by!(name: '金属(金)')
    find("##{dom_id(allergy)}").click

    within "##{dom_id(allergy)}" do
      accept_confirm '本当に削除しますか？' do
        find('#delete_button').click
      end
    end
    assert_no_selector "##{dom_id(allergy)}"
  end

  test 'guest user returns to top page' do
    visit allergies_url

    select_and_create_allergy(name: '金属(金)')
    assert_selector '#allergies', text: '金属(金)'

    click_on 'トップページに戻る'

    assert_current_path root_path
    assert_text 'Google アカウントでログイン'
    assert_text 'ログインせずに履歴書を作成'
  end

  test 'guest user saves skincare resume' do
    visit allergies_url

    select_and_create_allergy(name: '金属(金)')
    assert_selector '#allergies', text: '金属(金)'

    click_on '保存する'

    assert_current_path root_path

    within '#allergies-table' do
      row = find('tbody tr', text: '金属(金)')
      within row do
        assert_selector 'td:nth-child(1)', text: '金属(金)'
      end
    end
  end
end
