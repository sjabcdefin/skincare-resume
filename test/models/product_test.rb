# frozen_string_literal: true

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  setup do
    @resume = skincare_resumes(:with_user)
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
    product1 = products(:zoskin_cleanser)
    product2 = products(:nivea_cream)
    product3 = products(:collage_lotion)
    product4 = products(:collage_milk)
    result = @resume.products.order_for_display.to_a

    assert_equal [product2, product4, product3, product1], result
  end

  test 'order_for_print sorts correctly' do
    product1 = products(:zoskin_cleanser)
    product2 = products(:nivea_cream)
    product3 = products(:collage_lotion)
    product4 = products(:collage_milk)
    result = @resume.products.order_for_print.to_a

    assert_equal [product1, product3, product4, product2], result
  end

  test 'display_date returns started_on' do
    product = products(:zoskin_cleanser)

    assert_equal Date.new(2025, 12, 25), product.display_date
  end
end
