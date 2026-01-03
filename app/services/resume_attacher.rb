# frozen_string_literal: true

class ResumeAttacher
  def initialize(user:, session:)
    @user = user
    @session = session
  end

  def call
    current_resume.update!(user: @user)
    @session.delete('resume_uuid')
  end

  private

  def current_resume
    SkincareResume.find_by(uuid: @session['resume_uuid'])
  end
end
