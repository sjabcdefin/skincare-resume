# frozen_string_literal: true

require 'test_helper'

class MedicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = users(:alice)
    @guest_session = { 'resume_uuid' => skincare_resumes(:resume_without_user).uuid }
    @bepio_gel = medications(:bepio_gel)
    @differin_gel = medications(:differin_gel)
  end

  test 'gets index when logged in' do
    stub_current_user @alice do
      get medications_url
      assert_response :success
    end
  end

  test 'gets new when logged in' do
    stub_current_user @alice do
      get new_medication_url
      assert_response :success
    end
  end

  test 'creates medication when logged in' do
    stub_current_user @alice do
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

      medication = Medication.order(:id).last
      assert_equal 'ベピオゲル', medication.name
    end
  end

  test 'shows medication when logged in' do
    stub_current_user @alice do
      get medication_url(@bepio_gel)
      assert_response :success
    end
  end

  test 'gets edit when logged in' do
    stub_current_user @alice do
      get edit_medication_url(@bepio_gel)
      assert_response :success
    end
  end

  test 'updates medication when logged in' do
    stub_current_user @alice do
      patch medication_url(@bepio_gel),
            params: {
              medication: {
                started_on: Date.new(2025, 12, 24)
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type

      @bepio_gel.reload
      assert_equal Date.new(2025, 12, 24), @bepio_gel.started_on
    end
  end

  test 'destroys medication when logged in' do
    stub_current_user @alice do
      assert_difference('Medication.count', -1) do
        delete medication_url(@bepio_gel), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'does not create medication with invalid params' do
    stub_current_user @alice do
      assert_no_difference('Medication.count') do
        post medications_url,
             params: { medication: { name: '' } },
             as: :turbo_stream
      end
      assert_response :unprocessable_entity
    end
  end

  test 'does not update medication with invalid params' do
    stub_current_user @alice do
      patch medication_url(@bepio_gel),
            params: { medication: { name: '' } },
            as: :turbo_stream
      assert_response :unprocessable_entity
    end

    @bepio_gel.reload
    assert_equal 'ベピオゲル', @bepio_gel.name
  end

  test 'does not show other users medication' do
    stub_current_user users(:bob) do
      get medication_url(@bepio_gel)
      assert_response :not_found
    end
  end

  test 'gets index when guest with session' do
    stub_session @guest_session do
      get medications_url
      assert_response :success
    end
  end

  test 'creates medication when guest with session' do
    stub_session @guest_session do
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

      medication = Medication.order(:id).last
      assert_equal 'ベピオゲル', medication.name
    end
  end

  test 'updates medication when guest with session' do
    stub_session @guest_session do
      patch medication_url(@differin_gel),
            params: {
              medication: {
                started_on: Date.new(2025, 12, 24)
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type

      @differin_gel.reload
      assert_equal Date.new(2025, 12, 24), @differin_gel.started_on
    end
  end

  test 'destroys medication when guest with session' do
    stub_session @guest_session do
      assert_difference('Medication.count', -1) do
        delete medication_url(@differin_gel), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end
end
