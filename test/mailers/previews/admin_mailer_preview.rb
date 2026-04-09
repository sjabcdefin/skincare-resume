# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  delegate :job_failed, to: :AdminMailer
end
