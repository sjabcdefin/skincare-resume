# frozen_string_literal: true

require 'test_helper'

class AdminMailerTest < ActionMailer::TestCase
  test 'job_failed sends email with error information' do
    error = StandardError.new('test error')

    ENV['ALERT_EMAIL_ADDRESS'] = 'admin@gmail.com'
    ENV['MAIL_FROM_ADDRESS'] = 'skincare.resume.contact@gmail.com'

    assert_emails 1 do
      @email = AdminMailer.job_failed(error).deliver_now
    end

    assert_equal ['admin@gmail.com'], @email.to
    assert_equal ['skincare.resume.contact@gmail.com'], @email.from
    assert_equal '[Alert] Cleanup Job Failed', @email.subject
    assert_includes @email.text_part.body.to_s, 'test error'
    assert_includes @email.html_part.body.to_s, 'test error'
  end
end
