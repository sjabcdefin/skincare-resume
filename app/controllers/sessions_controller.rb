# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user = find_or_create_from_auth_hash(auth_hash)
    log_in(user) if user
    save_resume if session['resume_data']
    redirect_to root_path
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def find_or_create_from_auth_hash(auth_hash)
    email = auth_hash['info']['email']
    User.find_or_create_by(email: email)
  end

  def save_resume
    resume = current_user.create_skincare_resume!(status: status)

    save_products(resume)
    save_medications(resume)
    save_allergies(resume)
    save_treatments(resume)

    session.delete('resume_data')
  end

  def save_products(resume)
    products.each do |attrs|
      resume.products.create!(attrs.except('id', 'persisted'))
    end
  end

  def save_medications(resume)
    medications.each do |attrs|
      resume.medications.create!(attrs.except('id', 'persisted'))
    end
  end

  def save_allergies(resume)
    allergies.each do |attrs|
      resume.allergies.create!(attrs.except('id', 'persisted'))
    end
  end

  def save_treatments(resume)
    treatments.each do |attrs|
      resume.treatments.create!(attrs.except('id', 'persisted'))
    end
  end

  def status
    session.dig('resume_data', 'status')
  end

  def products
    session.dig('resume_data', 'products') || []
  end

  def medications
    session.dig('resume_data', 'medications') || []
  end

  def allergies
    session.dig('resume_data', 'allergies') || []
  end

  def treatments
    session.dig('resume_data', 'treatments') || []
  end
end
