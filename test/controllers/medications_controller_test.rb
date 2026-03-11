# frozen_string_literal: true

require 'test_helper'

class MedicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @session = { 'resume_uuid' => skincare_resumes(:one).uuid }
    @medication = medications(:one)
  end

  test 'should get index when logged in' do
    sign_in @user do
      get medications_url
      assert_response :success
    end
  end

  test 'should get new when logged in' do
    sign_in @user do
      get new_medication_url
      assert_response :success
    end
  end

  test 'should create medication when logged in' do
    sign_in @user do
      assert_difference('Medication.count') do
        post medications_url,
             params: {
               medication: {
                 name: 'ベピオゲル',
                 started_on: Date.new(2025, 12, 25)
               }
             },
             as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should show medication when logged in' do
    sign_in @user do
      get medication_url(@medication)
      assert_response :success
    end
  end

  test 'should get edit when logged in' do
    sign_in @user do
      get edit_medication_url(@medication)
      assert_response :success
    end
  end

  test 'should update medication when logged in' do
    sign_in @user do
      patch medication_url(@medication),
            params: {
              medication: {
                started_on: Date.new(2025, 12, 24)
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should destroy medication when logged in' do
    sign_in @user do
      assert_difference('Medication.count', -1) do
        delete medication_url(@medication), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should get index when not logged in' do
    with_session @session do
      get medications_url
      assert_response :success
    end
  end

  test 'should get new when not logged in' do
    with_session @session do
      get new_medication_url
      assert_response :success
    end
  end

  test 'should create medication when not logged in without session' do
    assert_difference('Medication.count') do
      post medications_url,
           params: {
             medication: {
               name: 'ベピオゲル',
               started_on: Date.new(2025, 12, 25)
             }
           },
           as: :turbo_stream
    end
    assert_response :success
    assert_equal 'text/vnd.turbo-stream.html', @response.media_type
  end

  test 'should create medication when not logged in' do
    with_session @session do
      assert_difference('Medication.count') do
        post medications_url,
             params: {
               medication: {
                 name: 'ベピオゲル',
                 started_on: Date.new(2025, 12, 25)
               }
             },
             as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should show medication when not logged in' do
    with_session @session do
      get medication_url(@medication)
      assert_response :success
    end
  end

  test 'should get edit when not logged in' do
    with_session @session do
      get edit_medication_url(@medication)
      assert_response :success
    end
  end

  test 'should update medication when not logged in' do
    with_session @session do
      patch medication_url(@medication),
            params: {
              medication: {
                started_on: Date.new(2025, 12, 24)
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should destroy medication when not logged in' do
    with_session @session do
      assert_difference('Medication.count', -1) do
        delete medication_url(@medication), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end
end
