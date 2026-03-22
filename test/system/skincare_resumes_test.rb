# frozen_string_literal: true

require 'application_system_test_case'

class SkincareResumesTest < ApplicationSystemTestCase
  test 'logged in user without resume sees resume summary' do
    login users(:bob)

    visit confirmation_skincare_resume_url

    assert_selector 'h1', text: '入力したスキンケアの履歴書の確認'
    assert_blank_table('products', 12)
    assert_blank_table('medications', 4)
    assert_blank_table('allergies', 4)
    assert_blank_table('treatments', 24)
  end

  test 'logged in user sees resume summary' do
    login users(:alice)

    visit confirmation_skincare_resume_url

    assert_selector 'h1', text: '入力したスキンケアの履歴書の確認'

    assert_table_row('products', 0, ['－', 'ニベアクリーム'])
    assert_table_row('products', 1, ['－', 'コラージュリペアミルク'])
    assert_table_row('products', 2, ['2024/12/25', 'コラージュリペアローション'])
    assert_table_row('products', 3, ['2025/12/25', 'ゼオスキン ハイドレーティングクレンザー'])
    assert_blank_rows('products', 4)

    assert_table_row('medications', 0, ['－', 'ヒルドイドローション'])
    assert_table_row('medications', 1, ['－', 'ビタミンD錠剤'])
    assert_table_row('medications', 2, ['2024/12/25', 'ビタミンC錠剤'])
    assert_table_row('medications', 3, ['2025/12/25', 'ベピオゲル'])

    assert_table_row('allergies', 0, ['金属(亜鉛)'])
    assert_table_row('allergies', 1, ['金属(銀)'])
    assert_table_row('allergies', 2, ['花粉(スギ)'])
    assert_blank_rows('allergies', 3)

    assert_table_row('treatments', 0, ['－', 'ミラノリピール'])
    assert_table_row('treatments', 1, ['－', 'ルメッカ'])
    assert_table_row('treatments', 2, ['2024/12/25', 'エレクトロポーション ケアシス'])
    assert_table_row('treatments', 3, ['2025/12/25', 'エレクトロポーション ケアシス'])
    assert_blank_rows('treatments', 4)
  end

  test 'logged in user returns to top page' do
    login users(:alice)

    visit confirmation_skincare_resume_url
    click_on 'トップページに戻る'

    assert_current_path root_path
    assert_selector '.display-area'
  end

  test 'shows overflow label when allergy rows exceed print limit' do
    login users(:carol)

    visit confirmation_skincare_resume_url

    assert_selector 'h1', text: '入力したスキンケアの履歴書の確認'

    row = all('#allergies-table tbody tr')[0]
    within row do
      assert_text '金属(ニッケル)'
      assert_text '印刷対象外'
    end
    assert_table_row('allergies', 1, ['金属(コバルト)'])
    assert_table_row('allergies', 2, ['花粉(イネ)'])
    assert_table_row('allergies', 3, ['花粉(ヨモギ)'])
    assert_table_row('allergies', 4, ['ピーナッツ'])
  end

  test 'guest user without resume sees resume summary' do
    visit confirmation_skincare_resume_url

    assert_selector 'h1', text: '入力したスキンケアの履歴書の確認'
    assert_blank_table('products', 12)
    assert_blank_table('medications', 4)
    assert_blank_table('allergies', 4)
    assert_blank_table('treatments', 24)
  end

  test 'guest user sees resume summary' do
    create_input_items

    visit confirmation_skincare_resume_url

    assert_selector 'h1', text: '入力したスキンケアの履歴書の確認'

    assert_table_row('products', 0, ['2025/12/25', 'NAVISION TAホワイトローション'])
    assert_blank_rows('products', 1)

    assert_table_row('medications', 0, ['－', 'ベピオローション'])
    assert_blank_rows('medications', 1)

    assert_table_row('allergies', 0, ['金属(金)'])
    assert_blank_rows('allergies', 1)

    assert_table_row('treatments', 0, ['2025/12/25', 'ヤグレーザー'])
    assert_blank_rows('treatments', 1)
  end

  test 'guest user returns to top page' do
    create_input_items

    visit confirmation_skincare_resume_url

    click_on 'トップページに戻る'

    assert_current_path root_path
    assert_text 'Google アカウントでログイン'
    assert_text 'ログインせずに履歴書を作成'
  end

  test 'guest user saves skincare resume' do
    create_input_items

    visit confirmation_skincare_resume_url

    click_on '保存する'

    assert_current_path root_path

    assert_table_row('products', 0, ['2025/12/25', 'NAVISION TAホワイトローション'])
    assert_blank_rows('products', 1)

    assert_table_row('medications', 0, ['－', 'ベピオローション'])
    assert_blank_rows('medications', 1)

    assert_table_row('allergies', 0, ['金属(金)'])
    assert_blank_rows('allergies', 1)

    assert_table_row('treatments', 0, ['2025/12/25', 'ヤグレーザー'])
    assert_blank_rows('treatments', 1)
  end

  test 'guest user cannot save skincare resume without resume' do
    visit confirmation_skincare_resume_url

    assert_selector 'button[disabled]', text: '保存する'
    assert_text '※ 履歴書の情報を登録すると保存できるようになります。'
  end

  test 'user can navigate between input steps' do
    visit confirmation_skincare_resume_url
    click_on '前へ'
    assert_current_path treatments_path

    click_on '次へ'
    assert_current_path confirmation_skincare_resume_url
  end

  test 'clicking logo returns to top page' do
    visit confirmation_skincare_resume_url
    find('#logo_title').click
    assert_current_path root_path
  end

  private

  def assert_blank_table(table, expected_rows)
    within ".display-area ##{table}-table" do
      rows = all('tbody tr')
      assert_equal expected_rows, rows.size

      rows.each do |row|
        td_row = row.all('td')
        td_row.each do |cell|
          assert_empty cell.text.strip
        end
      end
    end
  end

  def assert_blank_rows(table, inputted_rows)
    within ".display-area ##{table}-table" do
      rows = all('tbody tr')

      rows.drop(inputted_rows).each do |row|
        td_row = row.all('td')
        td_row.each do |cell|
          assert_empty cell.text.strip
        end
      end
    end
  end

  def assert_table_row(table, index, expected_values)
    within ".display-area ##{table}-table" do
      rows = all('tbody tr')
      cells = rows[index].all('td')
      expected_values.each_with_index do |value, i|
        assert_equal value, cells[i].text
      end
    end
  end
end
