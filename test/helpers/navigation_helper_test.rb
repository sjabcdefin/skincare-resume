# frozen_string_literal: true

require 'test_helper'

class NavigationHelperTest < ActionView::TestCase
  include NavigationHelper

  test 'nav_button includes previous arrow on left when direction is previous' do
    result = nav_button('前へ', products_path, direction: :previous)
    assert_includes result, '<a'
    assert_includes result, '＜'
    assert_includes result, '前へ'
    assert_not_includes result, '＞'
  end

  test 'nav_button includes next arrow on right when direction is next' do
    result = nav_button('次へ', allergies_path, direction: :next)
    assert_includes result, '<a'
    assert_includes result, '次へ'
    assert_includes result, '＞'
    assert_not_includes result, '＜'
  end

  test 'nav_button returns empty span when path is nil' do
    result = nav_button('前へ', nil, direction: :previous)
    assert_equal result, content_tag(:span, '', class: 'w-24')
  end
end
