# frozen_string_literal: true

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  setup do
    @resume = skincare_resumes(:resume_with_user)
  end

  test 'should save product with name' do
    product = @resume.products.new(name: 'ゼオスキン ハイドレーティングクレンザー')
    assert product.save
  end

  test 'order_for_display sorts by started_on asc with nulls first' do
    result = @resume.products.order_for_display.to_a

    assert_nil result.first.started_on
  end

  test 'order_for_display sorts by id when started_on is same' do
    cream = products(:nivea_cream)
    milk = products(:collage_milk)
    result = @resume.products.order_for_display.to_a

    assert_equal([cream, milk], result.select { |p| p.started_on.nil? })
  end

  test 'order_for_display sorts correctly' do
    cleanser = products(:zoskin_cleanser)
    cream = products(:nivea_cream)
    lotion = products(:collage_lotion)
    milk = products(:collage_milk)
    result = @resume.products.order_for_display.to_a

    assert_equal [cream, milk, lotion, cleanser], result
  end

  test 'order_for_print sorts by started_on desc with nulls last' do
    result = @resume.products.order_for_print.to_a

    assert_nil result.last.started_on
  end

  test 'order_for_print sorts by id when started_on is same' do
    cream = products(:nivea_cream)
    milk = products(:collage_milk)
    result = @resume.products.order_for_print.to_a

    assert_equal([milk, cream], result.select { |p| p.started_on.nil? })
  end

  test 'order_for_print sorts correctly' do
    cleanser = products(:zoskin_cleanser)
    cream = products(:nivea_cream)
    lotion = products(:collage_lotion)
    milk = products(:collage_milk)
    result = @resume.products.order_for_print.to_a

    assert_equal [cleanser, lotion, milk, cream], result
  end

  test 'display_date returns started_on when present' do
    product = products(:zoskin_cleanser)

    assert_equal Date.new(2025, 12, 25), product.display_date
  end

  test 'display_date returns nil when started_on is nil' do
    product = products(:nivea_cream)

    assert_nil product.display_date
  end
end
