# frozen_string_literal: true

require 'action_mailer'

class PaycheckMailer < ActionMailer::Base
  def call(email:, paycheck_file_path:)
    ActionMailer::Base.raise_delivery_errors = Config[:action_mailer][:raise_delivery_errors]
    ActionMailer::Base.delivery_method = Config[:action_mailer][:delivery_method]
    ActionMailer::Base.smtp_settings = Config[:action_mailer][:smtp_settings]

    attachments['paycheck.pdf'] = File.read(paycheck_file_path)
    mail(to: email, from: 'no-reply@baratao.mix', body: '', subject: 'PayCheck(Holerite)')
  end
end
