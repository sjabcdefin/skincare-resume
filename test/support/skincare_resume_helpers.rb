# frozen_string_literal: true

module SkincareResumeHelpers
  def create_product(name:, date: nil)
    within '#new_product' do
      fill_in '使用開始日', with: date if date.present?
      fill_in 'スキンケア製品名', with: name
      click_on '登録する'
    end
  end

  def create_medication(name:, date: nil)
    within '#new_medication' do
      fill_in '使用開始日', with: date if date.present?
      fill_in '薬名', with: name
      click_on '登録する'
    end
  end

  def select_and_create_allergy(name:)
    within '#new_allergy' do
      find('.ts-control').click
      find('.ts-dropdown-content .option', text: name).click
      click_on '登録する'
    end
  end

  def input_and_create_allergy(name:)
    within '#new_allergy' do
      find('.ts-control').click
      find('.ts-control input').set(name)
      find('.ts-dropdown-content .create', text: "#{name} を選択肢に追加します。").click
      click_on '登録する'
    end
  end

  def create_treatment(name:, date: nil)
    within '#new_treatment' do
      fill_in '治療日', with: date if date.present?
      fill_in '治療名', with: name
      click_on '登録する'
    end
  end

  def create_input_items
    visit products_url

    create_product(name: 'NAVISION TAホワイトローション', date: '002025/12/25')

    click_on '次へ'
    assert_current_path medications_path

    create_medication(name: 'ベピオローション')

    click_on '次へ'
    assert_current_path allergies_path

    select_and_create_allergy(name: '金属(金)')

    click_on '次へ'
    assert_current_path treatments_path

    create_treatment(date: '002025/12/25', name: 'ヤグレーザー')
  end
end
