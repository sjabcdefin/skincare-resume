# frozen_string_literal: true

require 'test_helper'

class SkincareResumeTest < ActiveSupport::TestCase
  setup do
    @resume = skincare_resumes(:resume_with_user)
  end

  test 'destroying skincare_resume destroys products' do
    assert_difference('Product.count', -@resume.products.count) do
      @resume.destroy!
    end
  end

  test 'destroying skincare_resume destroys allergies' do
    assert_difference('Allergy.count', -@resume.allergies.count) do
      @resume.destroy!
    end
  end

  test 'destroying skincare_resume destroys medications' do
    assert_difference('Medication.count', -@resume.medications.count) do
      @resume.destroy!
    end
  end

  test 'destroying skincare_resume destroys treatments' do
    assert_difference('Treatment.count', -@resume.treatments.count) do
      @resume.destroy!
    end
  end

  test 'filters resumes older than 3 days without user' do
    stale_guest_resume = SkincareResume.create!(
      user: nil,
      uuid: SecureRandom.uuid,
      created_at: 4.days.ago
    )

    SkincareResume.create!(
      user: nil,
      uuid: SecureRandom.uuid,
      created_at: 2.days.ago
    )

    SkincareResume.create!(
      uuid: SecureRandom.uuid,
      user: users(:alice),
      created_at: 10.days.ago
    )

    results = SkincareResume.stale_guest

    assert_includes results, stale_guest_resume
    assert_equal 1, results.count
  end
end
