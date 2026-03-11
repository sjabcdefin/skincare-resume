# frozen_string_literal: true

require 'test_helper'

class AllergiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @allergy = allergies(:one)
  end

  test 'should get index when logged in' do
    sign_in @user do
      get allergies_url
      assert_response :success
    end
  end

  test 'should get new when logged in' do
    sign_in @user do
      get new_allergy_url
      assert_response :success
    end
  end

  test 'should create allergy when logged in' do
    sign_in @user do
      assert_difference('Allergy.count') do
        post allergies_url,
             params: {
               allergy: {
                 name: '金属(酸化亜鉛)'
               }
             },
             as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should show allergy when logged in' do
    sign_in @user do
      get allergy_url(@allergy)
      assert_response :success
    end
  end

  test 'should get edit when logged in' do
    sign_in @user do
      get edit_allergy_url(@allergy)
      assert_response :success
    end
  end

  test 'should update allergy when logged in' do
    sign_in @user do
      patch allergy_url(@allergy),
            params: {
              allergy: {
                name: '金属(亜鉛)'
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should destroy allergy when logged in' do
    sign_in @user do
      assert_difference('Allergy.count', -1) do
        delete allergy_url(@allergy), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end
end
