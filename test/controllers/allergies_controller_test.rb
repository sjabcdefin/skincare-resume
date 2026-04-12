# frozen_string_literal: true

require 'test_helper'

class AllergiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = users(:alice)
    @guest_session = { 'resume_uuid' => skincare_resumes(:resume_without_user).uuid }
    @metal_zinc = allergies(:metal_zinc)
    @latex = allergies(:latex)
  end

  test 'gets index when logged in' do
    stub_current_user @alice do
      get allergies_url
      assert_response :success
    end
  end

  test 'gets new when logged in' do
    stub_current_user @alice do
      get new_allergy_url
      assert_response :success
    end
  end

  test 'creates allergy when logged in' do
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

      allergy = Allergy.order(:id).last
      assert_equal '金属(酸化亜鉛)', allergy.name
    end
  end

  test 'shows allergy when logged in' do
    stub_current_user @alice do
      get allergy_url(@metal_zinc)
      assert_response :success
    end
  end

  test 'gets edit when logged in' do
    stub_current_user @alice do
      get edit_allergy_url(@metal_zinc)
      assert_response :success
    end
  end

  test 'updates allergy when logged in' do
    stub_current_user @alice do
      patch allergy_url(@metal_zinc),
            params: {
              allergy: {
                name: '金属(酸化亜鉛)'
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type

      @metal_zinc.reload
      assert_equal '金属(酸化亜鉛)', @metal_zinc.name
    end
  end

  test 'destroys allergy when logged in' do
    stub_current_user @alice do
      assert_difference('Allergy.count', -1) do
        delete allergy_url(@metal_zinc), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end

  test 'does not create allergy with invalid params' do
    stub_current_user @alice do
      assert_no_difference('Allergy.count') do
        post allergies_url,
             params: { allergy: { name: '' } },
             as: :turbo_stream
      end
      assert_response :unprocessable_entity
    end
  end

  test 'does not update allergy with invalid params' do
    stub_current_user @alice do
      patch allergy_url(@metal_zinc),
            params: { allergy: { name: '' } },
            as: :turbo_stream
      assert_response :unprocessable_entity
    end

    @metal_zinc.reload
    assert_equal '金属(亜鉛)', @metal_zinc.name
  end

  test 'does not show other users allergy' do
    stub_current_user users(:bob) do
      get allergy_url(@metal_zinc)
      assert_response :not_found
    end
  end

  test 'gets index when guest with session' do
    stub_session @guest_session do
      get allergies_url
      assert_response :success
    end
  end

  test 'creates allergy when guest with session' do
    stub_session @guest_session do
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

      allergy = Allergy.order(:id).last
      assert_equal '金属(酸化亜鉛)', allergy.name
    end
  end

  test 'updates allergy when guest with session' do
    stub_session @guest_session do
      patch allergy_url(@latex),
            params: {
              allergy: {
                name: 'ラテックス(ゴム)'
              }
            },
            as: :turbo_stream
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type

      @latex.reload
      assert_equal 'ラテックス(ゴム)', @latex.name
    end
  end

  test 'destroys allergy when guest with session' do
    stub_session @guest_session do
      assert_difference('Allergy.count', -1) do
        delete allergy_url(@latex), as: :turbo_stream
      end
      assert_response :success
      assert_equal 'text/vnd.turbo-stream.html', @response.media_type
    end
  end
end
