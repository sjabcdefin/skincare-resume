# frozen_string_literal: true

require 'test_helper'

class AllergiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = users(:alice)
    @session = { 'resume_uuid' => skincare_resumes(:without_user).uuid }
    @metal_zinc = allergies(:metal_zinc)
    @latex = allergies(:latex)
  end

  test 'should get index when logged in' do
    stub_current_user @alice do
      get allergies_url
      assert_response :success
    end
  end

  test 'should get new when logged in' do
    stub_current_user @alice do
      get new_allergy_url
      assert_response :success
    end
  end

  test 'should create allergy when logged in' do
    stub_current_user @alice do
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
    stub_current_user @alice do
      get allergy_url(@metal_zinc)
      assert_response :success
    end
  end

  test 'should get edit when logged in' do
    stub_current_user @alice do
      get edit_allergy_url(@metal_zinc)
      assert_response :success
    end
  end

  test 'should update allergy when logged in' do
    stub_current_user @alice do
      patch allergy_url(@metal_zinc),
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
    stub_current_user @alice do
      assert_difference('Allergy.count', -1) do
        delete allergy_url(@metal_zinc), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should get index when not logged in' do
    stub_session @session do
      get allergies_url
      assert_response :success
    end
  end

  test 'should get new when not logged in' do
    stub_session @session do
      get new_allergy_url
      assert_response :success
    end
  end

  test 'should create allergy when not logged in without session' do
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

  test 'should create allergy when not logged in' do
    stub_session @session do
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

  test 'should show allergy when not logged in' do
    stub_session @session do
      get allergy_url(@latex)
      assert_response :success
    end
  end

  test 'should get edit when not logged in' do
    stub_session @session do
      get edit_allergy_url(@latex)
      assert_response :success
    end
  end

  test 'should update allergy when not logged in' do
    stub_session @session do
      patch allergy_url(@latex),
            params: {
              allergy: {
                name: 'ラテックス(ゴム)'
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should destroy allergy when not logged in' do
    stub_session @session do
      assert_difference('Allergy.count', -1) do
        delete allergy_url(@latex), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end
end
