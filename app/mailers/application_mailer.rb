# frozen_string_literal: true

# Default Mailer that generates emails
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
