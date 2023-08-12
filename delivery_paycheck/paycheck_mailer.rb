# frozen_string_literal: true

require 'action_mailer'

class PaycheckMailer < ActionMailer::Base
  def call(email:, paycheck_file_path:, config:)
    ActionMailer::Base.raise_delivery_errors = config[:action_mailer][:raise_delivery_errors]
    ActionMailer::Base.delivery_method = config[:action_mailer][:delivery_method]
    ActionMailer::Base.smtp_settings = config[:action_mailer][:smtp_settings]

    attachments['paycheck.pdf'] = File.read(paycheck_file_path)
    mail(to: email, from: 'no-reply@baratao.mix', body: '', subject: 'PayCheck(Holerite)')
  end
end
