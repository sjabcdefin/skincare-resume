# frozen_string_literal: true

require 'test_helper'

class TreatmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @session = { 'resume_uuid' => skincare_resumes(:one).uuid }
    @treatment = treatments(:one)
  end

  test 'should get index when logged in' do
    sign_in @user do
      get treatments_url
      assert_response :success
    end
  end

  test 'should get new when logged in' do
    sign_in @user do
      get new_treatment_url
      assert_response :success
    end
  end

  test 'should create treatment when logged in' do
    sign_in @user do
      assert_difference('Treatment.count') do
        post treatments_url,
             params: {
               treatment: {
                 name: 'エレクトロポーション ケアシス',
                 started_on: Date.new(2025, 12, 25)
               }
             },
             as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should show treatment when logged in' do
    sign_in @user do
      get treatment_url(@treatment)
      assert_response :success
    end
  end

  test 'should get edit when logged in' do
    sign_in @user do
      get edit_treatment_url(@treatment)
      assert_response :success
    end
  end

  test 'should update treatment when logged in' do
    sign_in @user do
      patch treatment_url(@treatment),
            params: {
              treatment: {
                started_on: Date.new(2025, 12, 24)
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should destroy treatment when logged in' do
    sign_in @user do
      assert_difference('Treatment.count', -1) do
        delete treatment_url(@treatment), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should get index when not logged in' do
    with_session @session do
      get treatments_url
      assert_response :success
    end
  end

  test 'should get new when not logged in' do
    with_session @session do
      get new_treatment_url
      assert_response :success
    end
  end

  test 'should create treatment when not logged in without session' do
    assert_difference('Treatment.count') do
      post treatments_url,
           params: {
             treatment: {
               name: 'エレクトロポーション ケアシス',
               started_on: Date.new(2025, 12, 25)
             }
           },
           as: :turbo_stream
    end
    assert_response :success
    assert_equal 'text/vnd.turbo-stream.html', @response.media_type
  end

  test 'should create treatment when not logged in' do
    with_session @session do
      assert_difference('Treatment.count') do
        post treatments_url,
             params: {
               treatment: {
                 name: 'エレクトロポーション ケアシス',
                 started_on: Date.new(2025, 12, 25)
               }
             },
             as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should show treatment when not logged in' do
    with_session @session do
      get treatment_url(@treatment)
      assert_response :success
    end
  end

  test 'should get edit when not logged in' do
    with_session @session do
      get edit_treatment_url(@treatment)
      assert_response :success
    end
  end

  test 'should update treatment when not logged in' do
    with_session @session do
      patch treatment_url(@treatment),
            params: {
              treatment: {
                started_on: Date.new(2025, 12, 24)
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'should destroy treatment when not logged in' do
    with_session @session do
      assert_difference('Treatment.count', -1) do
        delete treatment_url(@treatment), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end
end
