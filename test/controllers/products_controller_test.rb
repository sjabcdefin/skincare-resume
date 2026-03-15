# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = users(:alice)
    @session = { 'resume_uuid' => skincare_resumes(:without_user).uuid }
    @zoskin_cleanser = products(:zoskin_cleanser)
    @curel_lotion = products(:curel_lotion)
  end

  test 'should get index when logged in' do
    sign_in @alice do
      get products_url
      assert_response :success
    end
  end

  test 'should get new when logged in' do
    sign_in @alice do
      get new_product_url
      assert_response :success
    end
  end

  test 'should create product when logged in' do
    sign_in @alice do
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
    sign_in @alice do
      get product_url(@zoskin_cleanser)
      assert_response :success
    end
  end

  test 'should get edit when logged in' do
    sign_in @alice do
      get edit_product_url(@zoskin_cleanser)
      assert_response :success
    end
  end

  test 'should update product when logged in' do
    sign_in @alice do
      patch product_url(@zoskin_cleanser),
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
    sign_in @alice do
      assert_difference('Product.count', -1) do
        delete product_url(@zoskin_cleanser), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should get index when not logged in' do
    with_session @session do
      get products_url
      assert_response :success
    end
  end

  test 'should get new when not logged in' do
    with_session @session do
      get new_product_url
      assert_response :success
    end
  end

  test 'should create product when not logged in without session' do
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

  test 'should create product when not logged in' do
    with_session @session do
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

  test 'should show product when not logged in' do
    with_session @session do
      get product_url(@curel_lotion)
      assert_response :success
    end
  end

  test 'should get edit when not logged in' do
    with_session @session do
      get edit_product_url(@curel_lotion)
      assert_response :success
    end
  end

  test 'should update product when not logged in' do
    with_session @session do
      patch product_url(@curel_lotion),
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

  test 'should destroy product when not logged in' do
    with_session @session do
      assert_difference('Product.count', -1) do
        delete product_url(@curel_lotion), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end
end
