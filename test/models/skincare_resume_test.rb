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
end
