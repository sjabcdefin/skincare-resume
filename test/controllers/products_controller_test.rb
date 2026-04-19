# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = users(:alice)
    @guest_session = { 'resume_uuid' => skincare_resumes(:resume_without_user).uuid }
  end

  test 'gets index when logged in with resume' do
    stub_current_user @alice do
      get products_url
      assert_response :success
    end
  end

  test 'gets index when logged in without resume' do
    stub_current_user @bob do
      get products_url
      assert_response :success
    end
  end

  test 'gets new when logged in' do
    stub_current_user @alice do
      get new_product_url
      assert_response :success
    end
  end

  test 'creates product when logged in' do
    stub_current_user @alice do
      assert_difference('Product.count') do
        post products_url,
             params: {
               product: {
                 name: 'NAVISION TAホワイトローション',
                 started_on: Date.new(2025, 12, 25)
               }
             },
             as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type

      product = Product.order(:id).last
      assert_equal 'NAVISION TAホワイトローション', product.name
    end
  end

  test 'gets edit when logged in' do
    zoskin_cleanser = products(:zoskin_cleanser)

    stub_current_user @alice do
      get edit_product_url(zoskin_cleanser)
      assert_response :success
    end
  end

  test 'updates product when logged in' do
    zoskin_cleanser = products(:zoskin_cleanser)

    stub_current_user @alice do
      patch product_url(zoskin_cleanser),
            params: {
              product: {
                started_on: Date.new(2025, 12, 24)
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type

      zoskin_cleanser.reload
      assert_equal Date.new(2025, 12, 24), zoskin_cleanser.started_on
    end
  end

  test 'destroys product when logged in' do
    zoskin_cleanser = products(:zoskin_cleanser)

    stub_current_user @alice do
      assert_difference('Product.count', -1) do
        delete product_url(zoskin_cleanser), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'gets index when guest with session' do
    stub_session @guest_session do
      get products_url
      assert_response :success
    end
  end

  test 'gets index when guest without session' do
    get products_url
    assert_response :success
  end

  test 'gets new when guest with session' do
    stub_session @guest_session do
      get new_product_url
      assert_response :success
    end
  end

  test 'creates product when guest with session' do
    stub_session @guest_session do
      assert_difference('Product.count') do
        post products_url,
             params: {
               product: {
                 name: 'NAVISION TAホワイトローション',
                 started_on: Date.new(2025, 12, 25)
               }
             },
             as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type

      product = Product.order(:id).last
      assert_equal 'NAVISION TAホワイトローション', product.name
    end
  end

  test 'gets edit when guest with session' do
    curel_lotion = products(:curel_lotion)

    stub_session @guest_session do
      get edit_product_url(curel_lotion)
      assert_response :success
    end
  end

  test 'updates product when guest with session' do
    curel_lotion = products(:curel_lotion)

    stub_session @guest_session do
      patch product_url(curel_lotion),
            params: {
              product: {
                started_on: Date.new(2025, 12, 24)
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type

      curel_lotion.reload
      assert_equal Date.new(2025, 12, 24), curel_lotion.started_on
    end
  end

  test 'destroys product when guest with session' do
    curel_lotion = products(:curel_lotion)

    stub_session @guest_session do
      assert_difference('Product.count', -1) do
        delete product_url(curel_lotion), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'does not create product with invalid params' do
    stub_current_user @alice do
      assert_no_difference('Product.count') do
        post products_url,
             params: { product: { name: '' } },
             as: :turbo_stream
      end
      assert_response :unprocessable_entity
    end
  end

  test 'does not update product with invalid params' do
    zoskin_cleanser = products(:zoskin_cleanser)

    stub_current_user @alice do
      patch product_url(zoskin_cleanser),
            params: { product: { name: '' } },
            as: :turbo_stream
      assert_response :unprocessable_entity
    end

    zoskin_cleanser.reload
    assert_equal 'ゼオスキン ハイドレーティングクレンザー', zoskin_cleanser.name
  end
end
