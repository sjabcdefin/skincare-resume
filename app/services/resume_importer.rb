# frozen_string_literal: true

class ResumeImporter
  def initialize(user:, session:)
    @user = user
    @session = session
  end

  def call
    resume = @user.create_skincare_resume!(status: status)

    %w[products medications allergies treatments].each do |key|
      save_entries(resume, key)
    end

    @session.delete('resume_data')
  end

  private

  def save_entries(resume, key)
    entries = @session.dig('resume_data', key).to_a
    entries.each do |attrs|
      resume.public_send(key).create!(attrs.except('id', 'persisted'))
    end
  end

  def status
    @session.dig('resume_data', 'status')
  end
end
