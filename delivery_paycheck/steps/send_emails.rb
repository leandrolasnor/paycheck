# frozen_string_literal: true

require './delivery_paycheck/paycheck_mailer.rb'

class SendEmails
  include Dry::Monads[:result, :try]
  extend Dry::Initializer

  option :mailer, default: -> { PaycheckMailer }

  def call(people_list:, config:)
    res = Try do
      people_list.map do
        mail = mailer.(
          email: _1.email,
          paycheck_file_path: _1.paycheck_file_path,
          config: config
        )
        mail.deliver_now
      end
    end

    res.failure? ? Failure(res.exception) : Success(res.value!)
  ensure
    FileUtils.remove_dir(File.absolute_path('pages'))
  end
end
