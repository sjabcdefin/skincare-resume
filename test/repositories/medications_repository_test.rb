# frozen_string_literal: true

require 'test_helper'

class MedicationsRepositoryTest < ActiveSupport::TestCase
  test 'returns medications when logged in' do
    user = users(:alice)
    repository = MedicationsRepository.new(user:, session: {})

    assert_equal user.skincare_resume.medications, repository.all
  end

  test 'returns none when user has no resume' do
    user = users(:bob)
    repository = MedicationsRepository.new(user:, session: {})

    assert_empty repository.all
  end

  test 'finds medication when logged in' do
    bepio_gel = medications(:bepio_gel)

    user = users(:alice)
    repository = MedicationsRepository.new(user:, session: {})

    assert_equal bepio_gel, repository.find(bepio_gel.id)
  end

  test 'raises RecordNotFound when medication not found when logged in' do
    bepio_gel = medications(:bepio_gel)

    user = users(:bob)
    repository = MedicationsRepository.new(user:, session: {})

    assert_raises(ActiveRecord::RecordNotFound) do
      repository.find(bepio_gel.id)
    end
  end

  test 'builds medication with resume when logged in' do
    user = users(:alice)
    repository = MedicationsRepository.new(user:, session: {})

    medication = repository.build(name: 'トラネキサム酸')
    assert medication.skincare_resume.persisted?
  end

  test 'builds medication without resume when logged in' do
    user = users(:bob)
    repository = MedicationsRepository.new(user:, session: {})

    assert_difference('SkincareResume.count', 1) do
      medication = repository.build(name: 'トラネキサム酸')
      assert medication.skincare_resume.persisted?
    end
  end

  test 'returns medications from session when guest' do
    resume = skincare_resumes(:resume_without_user)
    session = { 'resume_uuid' => resume.uuid }
    repository = MedicationsRepository.new(user: nil, session:)

    assert_equal resume.medications, repository.all
  end

  test 'returns none when guest has no resume' do
    repository = MedicationsRepository.new(user: nil, session: {})

    assert_empty repository.all
  end

  test 'finds medication from session when guest' do
    differin_gel = medications(:differin_gel)

    resume = skincare_resumes(:resume_without_user)
    session = { 'resume_uuid' => resume.uuid }
    repository = MedicationsRepository.new(user: nil, session:)

    assert_equal differin_gel, repository.find(differin_gel.id)
  end

  test 'raises RecordNotFound when guest has no resume' do
    differin_gel = medications(:differin_gel)

    repository = MedicationsRepository.new(user: nil, session: {})

    assert_raises(ActiveRecord::RecordNotFound) do
      repository.find(differin_gel.id)
    end
  end

  test 'builds medication when guest with session' do
    resume = skincare_resumes(:resume_without_user)
    session = { 'resume_uuid' => resume.uuid }
    repository = MedicationsRepository.new(user: nil, session:)

    medication = repository.build(name: 'トラネキサム酸')
    assert medication.skincare_resume.persisted?
  end

  test 'builds medication when guest without session' do
    session = {}
    repository = MedicationsRepository.new(user: nil, session:)

    assert_difference('SkincareResume.count', 1) do
      medication = repository.build(name: 'トラネキサム酸')
      assert medication.skincare_resume.persisted?
    end

    assert_not_nil session['resume_uuid']
  end

  test 'prioritizes user over session when logged in' do
    user = users(:alice)
    session = { 'resume_uuid' => skincare_resumes(:resume_without_user).uuid }

    repository = MedicationsRepository.new(user:, session:)

    assert_equal user.skincare_resume.medications, repository.all
  end
end
