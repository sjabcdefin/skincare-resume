# frozen_string_literal: true

require 'test_helper'

class ProductsRepositoryTest < ActiveSupport::TestCase
  test 'returns products when logged in' do
    user = users(:alice)
    repository = ProductsRepository.new(user:, session: {})

    assert_equal user.skincare_resume.products, repository.all
  end

  test 'returns none when user has no resume' do
    user = users(:bob)
    repository = ProductsRepository.new(user:, session: {})

    assert_empty repository.all
  end

  test 'finds product when logged in' do
    cleanser = products(:zoskin_cleanser)

    user = users(:alice)
    repository = ProductsRepository.new(user:, session: {})

    assert_equal cleanser, repository.find(cleanser.id)
  end

  test 'raises RecordNotFound when product not found when logged in' do
    cleanser = products(:zoskin_cleanser)

    user = users(:bob)
    repository = ProductsRepository.new(user:, session: {})

    assert_raises(ActiveRecord::RecordNotFound) do
      repository.find(cleanser.id)
    end
  end

  test 'builds product with resume when logged in' do
    user = users(:alice)
    repository = ProductsRepository.new(user:, session: {})

    product = repository.build(name: 'シートマスク')
    assert product.skincare_resume.persisted?
  end

  test 'builds product without resume when logged in' do
    user = users(:bob)
    repository = ProductsRepository.new(user:, session: {})

    assert_difference('SkincareResume.count', 1) do
      product = repository.build(name: 'シートマスク')
      assert product.skincare_resume.persisted?
    end
  end

  test 'returns products from session when guest' do
    resume = skincare_resumes(:resume_without_user)
    session = { 'resume_uuid' => resume.uuid }
    repository = ProductsRepository.new(user: nil, session:)

    assert_equal resume.products, repository.all
  end

  test 'returns none when guest has no resume' do
    repository = ProductsRepository.new(user: nil, session: {})

    assert_empty repository.all
  end

  test 'finds product from session when guest' do
    lotion = products(:curel_lotion)

    resume = skincare_resumes(:resume_without_user)
    session = { 'resume_uuid' => resume.uuid }
    repository = ProductsRepository.new(user: nil, session:)

    assert_equal lotion, repository.find(lotion.id)
  end

  test 'raises RecordNotFound when guest has no resume' do
    lotion = products(:curel_lotion)

    repository = ProductsRepository.new(user: nil, session: {})

    assert_raises(ActiveRecord::RecordNotFound) do
      repository.find(lotion.id)
    end
  end

  test 'builds product when guest with session' do
    resume = skincare_resumes(:resume_without_user)
    session = { 'resume_uuid' => resume.uuid }
    repository = ProductsRepository.new(user: nil, session:)

    product = repository.build(name: 'シートマスク')
    assert product.skincare_resume.persisted?
  end

  test 'builds product when guest without session' do
    session = {}
    repository = ProductsRepository.new(user: nil, session:)

    assert_difference('SkincareResume.count', 1) do
      product = repository.build(name: 'シートマスク')
      assert product.skincare_resume.persisted?
    end

    assert_not_nil session['resume_uuid']
  end

  test 'prioritizes user over session when logged in' do
    user = users(:alice)
    session = { 'resume_uuid' => skincare_resumes(:resume_without_user).uuid }

    repository = ProductsRepository.new(user:, session:)

    assert_equal user.skincare_resume.products, repository.all
  end
end
