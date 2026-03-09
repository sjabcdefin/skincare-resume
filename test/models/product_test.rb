# frozen_string_literal: true

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  setup do
    @resume = skincare_resumes(:one)
  end

  test 'should not save product without name' do
    product = @resume.products.new
    assert_not product.save
  end

  test 'should save product with name' do
    product = @resume.products.new(name: 'ゼオスキン ハイドレーティングクレンザー')
    assert product.save
  end

  test 'order_for_display sorts correctly' do
    product1 = products(:one)
    product2 = products(:two)
    product3 = products(:three)
    product4 = products(:four)
    result = @resume.products.order_for_display.to_a

    assert_equal [product2, product4, product3, product1], result
  end

  test 'order_for_print sorts correctly' do
    product1 = products(:one)
    product2 = products(:two)
    product3 = products(:three)
    product4 = products(:four)
    result = @resume.products.order_for_print.to_a

    assert_equal [product1, product3, product4, product2], result
  end

  test 'display_date returns started_on' do
    product = products(:one)

    assert_equal Date.new(2025, 12, 25), product.display_date
  end
end
