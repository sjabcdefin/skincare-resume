# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @product = products(:one)
  end

  test 'should get index when logged in' do
    sign_in @user do
      get products_url
      assert_response :success
    end
  end

  test 'should get new when logged in' do
    sign_in @user do
      get new_product_url
      assert_response :success
    end
  end

  test 'should create product when logged in' do
    sign_in @user do
      assert_difference('Product.count') do
        post products_url,
             params: {
               product: {
                 name: 'コラージュリペアミルク',
                 started_on: Date.new(2025, 12, 25)
               }
             },
             as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should show product when logged in' do
    sign_in @user do
      get product_url(@product)
      assert_response :success
    end
  end

  test 'should get edit when logged in' do
    sign_in @user do
      get edit_product_url(@product)
      assert_response :success
    end
  end

  test 'should update product when logged in' do
    sign_in @user do
      patch product_url(@product),
            params: {
              product: {
                started_on: Date.new(2025, 12, 24)
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should destroy product when logged in' do
    sign_in @user do
      assert_difference('Product.count', -1) do
        delete product_url(@product), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end
end
