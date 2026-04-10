# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def job_failed(error)
    @error = error
    @time = Time.current.strftime('%Y-%m-%d %H:%M:%S')
    mail(
      to: ENV['ALERT_EMAIL_ADDRESS'],
      subject: '[Alert] Cleanup Job Failed'
    )
  end
end
