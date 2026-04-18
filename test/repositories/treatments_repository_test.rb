# frozen_string_literal: true

require 'test_helper'

class TreatmentsRepositoryTest < ActiveSupport::TestCase
  test 'returns treatments when logged in' do
    user = users(:alice)
    repository = TreatmentsRepository.new(user:, session: {})

    assert_equal user.skincare_resume.treatments, repository.all
  end

  test 'returns none when user has no resume' do
    user = users(:bob)
    repository = TreatmentsRepository.new(user:, session: {})

    assert_empty repository.all
  end

  test 'finds treatment when logged in' do
    caresys = treatments(:caresys_recent)

    user = users(:alice)
    repository = TreatmentsRepository.new(user:, session: {})

    assert_equal caresys, repository.find(caresys.id)
  end

  test 'raises RecordNotFound when treatment not found when logged in' do
    caresys = treatments(:caresys_recent)

    user = users(:bob)
    repository = TreatmentsRepository.new(user:, session: {})

    assert_raises(ActiveRecord::RecordNotFound) do
      repository.find(caresys.id)
    end
  end

  test 'builds treatment with resume when logged in' do
    user = users(:alice)
    repository = TreatmentsRepository.new(user:, session: {})

    treatment = repository.build(name: '脱毛')
    assert treatment.skincare_resume.persisted?
  end

  test 'builds treatment without resume when logged in' do
    user = users(:bob)
    repository = TreatmentsRepository.new(user:, session: {})

    assert_difference('SkincareResume.count', 1) do
      treatment = repository.build(name: '脱毛')
      assert treatment.skincare_resume.persisted?
    end
  end

  test 'returns treatments from session when guest' do
    resume = skincare_resumes(:resume_without_user)
    session = { 'resume_uuid' => resume.uuid }
    repository = TreatmentsRepository.new(user: nil, session:)

    assert_equal resume.treatments, repository.all
  end

  test 'returns none when guest has no resume' do
    repository = TreatmentsRepository.new(user: nil, session: {})

    assert_empty repository.all
  end

  test 'finds treatment from session when guest' do
    massage_peel = treatments(:massage_peel)

    resume = skincare_resumes(:resume_without_user)
    session = { 'resume_uuid' => resume.uuid }
    repository = TreatmentsRepository.new(user: nil, session:)

    assert_equal massage_peel, repository.find(massage_peel.id)
  end

  test 'raises RecordNotFound when guest has no resume' do
    massage_peel = treatments(:massage_peel)

    repository = TreatmentsRepository.new(user: nil, session: {})

    assert_raises(ActiveRecord::RecordNotFound) do
      repository.find(massage_peel.id)
    end
  end

  test 'builds treatment when guest with session' do
    resume = skincare_resumes(:resume_without_user)
    session = { 'resume_uuid' => resume.uuid }
    repository = TreatmentsRepository.new(user: nil, session:)

    treatment = repository.build(name: '脱毛')
    assert treatment.skincare_resume.persisted?
  end

  test 'builds treatment when guest without session' do
    session = {}
    repository = TreatmentsRepository.new(user: nil, session:)

    assert_difference('SkincareResume.count', 1) do
      treatment = repository.build(name: '脱毛')
      assert treatment.skincare_resume.persisted?
    end

    assert_not_nil session['resume_uuid']
  end

  test 'prioritizes user over session when logged in' do
    user = users(:alice)
    session = { 'resume_uuid' => skincare_resumes(:resume_without_user).uuid }

    repository = TreatmentsRepository.new(user:, session:)

    assert_equal user.skincare_resume.treatments, repository.all
  end
end
