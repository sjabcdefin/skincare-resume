# frozen_string_literal: true

require 'application_system_test_case'

class ProductsTest < ApplicationSystemTestCase
  test 'logged in user without resume sees product form' do
    login users(:bob)

    visit products_url
    assert_selector 'h1', text: '使用しているスキンケア製品'
    assert_selector '#new_product'
  end

  test 'logged in user creates product' do
    login users(:alice)

    visit products_url
    find('#add-form-button').click
    assert_selector '#new_product'

    create_product(date: '002025/12/25', name: 'NAVISION TAホワイトローション')
    assert_text '2025/12/25'
    assert_text 'NAVISION TAホワイトローション'
  end

  test 'logged in user updates product' do
    login users(:alice)

    visit products_url
    product = Product.find_by!(name: 'コラージュリペアミルク')
    find("##{dom_id(product)}").click

    within "##{dom_id(product)}" do
      fill_in 'スキンケア製品名', with: 'NAVISION TAホワイトエマルジョン'
      click_on '更新する'
      assert_text 'NAVISION TAホワイトエマルジョン'
    end
  end

  test 'logged in user destorys product' do
    login users(:alice)

    visit products_url
    product = Product.find_by!(name: 'コラージュリペアミルク')
    find("##{dom_id(product)}").click

    within "##{dom_id(product)}" do
      accept_confirm '本当に削除しますか？' do
        find('#delete_button').click
      end
    end
    assert_no_selector "##{dom_id(product)}"
  end

  test 'logged in user returns to top page' do
    login users(:alice)

    visit products_url
    click_on 'トップページに戻る'

    assert_current_path root_path
    assert_selector '#products-table'
  end

  test 'guest user without resume sees product form' do
    visit products_url
    assert_selector 'h1', text: '使用しているスキンケア製品'
    assert_selector '#new_product'
  end

  test 'guest user creates product' do
    visit products_url

    create_product(date: '002025/12/25', name: 'NAVISION TAホワイトローション')
    assert_text '2025/12/25'
    assert_text 'NAVISION TAホワイトローション'
  end

  test 'guest user updates product' do
    visit products_url

    create_product(name: 'NAVISION TAホワイトローション')
    assert_selector '#products', text: 'NAVISION TAホワイトローション'

    product = Product.find_by!(name: 'NAVISION TAホワイトローション')
    find("##{dom_id(product)}").click

    within "##{dom_id(product)}" do
      fill_in 'スキンケア製品名', with: 'NAVISION TAホワイトエマルジョン'
      click_on '更新する'
      assert_text 'NAVISION TAホワイトエマルジョン'
    end
  end

  test 'guest user destorys product' do
    visit products_url

    create_product(name: 'NAVISION TAホワイトローション')
    assert_selector '#products', text: 'NAVISION TAホワイトローション'

    product = Product.find_by!(name: 'NAVISION TAホワイトローション')
    find("##{dom_id(product)}").click

    within "##{dom_id(product)}" do
      accept_confirm '本当に削除しますか？' do
        find('#delete_button').click
      end
    end
    assert_no_selector "##{dom_id(product)}"
  end

  test 'guest user returns to top page' do
    visit products_url

    create_product(name: 'NAVISION TAホワイトローション')
    assert_selector '#products', text: 'NAVISION TAホワイトローション'

    click_on 'トップページに戻る'

    assert_current_path root_path
    assert_text 'Google アカウントでログイン'
    assert_text 'ログインせずに履歴書を作成'
  end

  test 'guest user saves skincare resume' do
    visit products_url

    create_product(name: 'NAVISION TAホワイトローション', date: '002025/12/25')
    assert_selector '#products', text: 'NAVISION TAホワイトローション'

    click_on '保存する'

    assert_current_path root_path

    within '#products-table' do
      row = find('tbody tr', text: 'NAVISION TAホワイトローション')
      within row do
        assert_selector 'td:nth-child(1)', text: '2025/12/25'
        assert_selector 'td:nth-child(2)', text: 'NAVISION TAホワイトローション'
      end
    end
  end
end
