# frozen_string_literal: true

require 'test_helper'

class AllergiesRepositoryTest < ActiveSupport::TestCase
  test 'returns allergies when logged in' do
    user = users(:alice)
    repository = AllergiesRepository.new(user:, session: {})

    assert_equal user.skincare_resume.allergies, repository.all
  end

  test 'returns none when user has no resume' do
    user = users(:bob)
    repository = AllergiesRepository.new(user:, session: {})

    assert_empty repository.all
  end

  test 'finds allergy when logged in' do
    metal_zinc = allergies(:metal_zinc)

    user = users(:alice)
    repository = AllergiesRepository.new(user:, session: {})

    assert_equal metal_zinc, repository.find(metal_zinc.id)
  end

  test 'raises RecordNotFound when allergy not found when logged in' do
    metal_zinc = allergies(:metal_zinc)

    user = users(:bob)
    repository = AllergiesRepository.new(user:, session: {})

    assert_raises(ActiveRecord::RecordNotFound) do
      repository.find(metal_zinc.id)
    end
  end

  test 'builds allergy with resume when logged in' do
    user = users(:alice)
    repository = AllergiesRepository.new(user:, session: {})

    allergy = repository.build(name: '乳製品')
    assert allergy.skincare_resume.persisted?
  end

  test 'builds allergy without resume when logged in' do
    user = users(:bob)
    repository = AllergiesRepository.new(user:, session: {})

    assert_difference('SkincareResume.count', 1) do
      allergy = repository.build(name: '乳製品')
      assert allergy.skincare_resume.persisted?
    end
  end

  test 'returns allergies from session when guest' do
    resume = skincare_resumes(:resume_without_user)
    session = { 'resume_uuid' => resume.uuid }
    repository = AllergiesRepository.new(user: nil, session:)

    assert_equal resume.allergies, repository.all
  end

  test 'returns none when guest has no resume' do
    repository = AllergiesRepository.new(user: nil, session: {})

    assert_empty repository.all
  end

  test 'finds allergy from session when guest' do
    latex = allergies(:latex)

    resume = skincare_resumes(:resume_without_user)
    session = { 'resume_uuid' => resume.uuid }
    repository = AllergiesRepository.new(user: nil, session:)

    assert_equal latex, repository.find(latex.id)
  end

  test 'raises RecordNotFound when guest has no resume' do
    latex = allergies(:latex)

    repository = AllergiesRepository.new(user: nil, session: {})

    assert_raises(ActiveRecord::RecordNotFound) do
      repository.find(latex.id)
    end
  end

  test 'builds allergy when guest with session' do
    resume = skincare_resumes(:resume_without_user)
    session = { 'resume_uuid' => resume.uuid }
    repository = AllergiesRepository.new(user: nil, session:)

    allergy = repository.build(name: '乳製品')
    assert allergy.skincare_resume.persisted?
  end

  test 'builds allergy when guest without session' do
    session = {}
    repository = AllergiesRepository.new(user: nil, session:)

    assert_difference('SkincareResume.count', 1) do
      allergy = repository.build(name: '乳製品')
      assert allergy.skincare_resume.persisted?
    end

    assert_not_nil session['resume_uuid']
  end

  test 'prioritizes user over session when logged in' do
    user = users(:alice)
    session = { 'resume_uuid' => skincare_resumes(:resume_without_user).uuid }

    repository = AllergiesRepository.new(user:, session:)

    assert_equal user.skincare_resume.allergies, repository.all
  end
end
