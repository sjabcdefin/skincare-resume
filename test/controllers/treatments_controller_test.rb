# frozen_string_literal: true

require 'test_helper'

class TreatmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = users(:alice)
    @guest_session = { 'resume_uuid' => skincare_resumes(:resume_without_user).uuid }
    @caresys_recent = treatments(:caresys_recent)
    @massage_peel = treatments(:massage_peel)
  end

  test 'gets index when logged in' do
    stub_current_user @alice do
      get treatments_url
      assert_response :success
    end
  end

  test 'gets new when logged in' do
    stub_current_user @alice do
      get new_treatment_url
      assert_response :success
    end
  end

  test 'creates treatment when logged in' do
    stub_current_user @alice do
      assert_difference('Treatment.count') do
        post treatments_url,
             params: {
               treatment: {
                 name: 'エレクトロポーション ケアシス',
                 treated_on: Date.new(2025, 12, 25)
               }
             },
             as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'gets edit when logged in' do
    stub_current_user @alice do
      get edit_treatment_url(@caresys_recent)
      assert_response :success
    end
  end

  test 'updates treatment when logged in' do
    stub_current_user @alice do
      patch treatment_url(@caresys_recent),
            params: {
              treatment: {
                treated_on: Date.new(2025, 12, 24)
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'destroys treatment when logged in' do
    stub_current_user @alice do
      assert_difference('Treatment.count', -1) do
        delete treatment_url(@caresys_recent), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'does not create treatment with invalid params' do
    stub_current_user @alice do
      assert_no_difference('Treatment.count') do
        post treatments_url,
             params: { treatment: { name: '' } },
             as: :turbo_stream
      end
      assert_response :unprocessable_entity
    end
  end

  test 'does not update treatment with invalid params' do
    stub_current_user @alice do
      patch treatment_url(@caresys_recent),
            params: { treatment: { name: '' } },
            as: :turbo_stream
      assert_response :unprocessable_entity
    end

    @caresys_recent.reload
    assert_equal 'エレクトロポーション ケアシス', @caresys_recent.name
  end

  test 'gets index when guest with session' do
    stub_session @guest_session do
      get treatments_url
      assert_response :success
    end
  end

  test 'creates treatment when guest with session' do
    stub_session @guest_session do
      assert_difference('Treatment.count') do
        post treatments_url,
             params: {
               treatment: {
                 name: 'エレクトロポーション ケアシス',
                 treated_on: Date.new(2025, 12, 25)
               }
             },
             as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type

      treatment = Treatment.order(:id).last
      assert_equal 'エレクトロポーション ケアシス', treatment.name
    end
  end

  test 'updates treatment when guest with session' do
    stub_session @guest_session do
      patch treatment_url(@massage_peel),
            params: {
              treatment: {
                treated_on: Date.new(2025, 12, 24)
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type

      @massage_peel.reload
      assert_equal Date.new(2025, 12, 24), @massage_peel.treated_on
    end
  end

  test 'destroys treatment when guest with session' do
    stub_session @guest_session do
      assert_difference('Treatment.count', -1) do
        delete treatment_url(@massage_peel), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end
end
