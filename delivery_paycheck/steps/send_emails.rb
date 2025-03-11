# frozen_string_literal: true

require './delivery_paycheck/paycheck_mailer.rb'

class SendEmails
  include Dry::Monads[:result]
  include Dry::Events::Publisher[:sender]
  extend Dry::Initializer

  option :mailer, default: -> { PaycheckMailer }

  register_event 'paycheck.sended'

  def call(people_list:)
    people_list.map do |person|
      mailer.(email: person.email, paycheck_file_path: person.paycheck_file_path).deliver_now
      publish('paycheck.sended', person: person)
    end
  ensure
    FileUtils.remove_dir(File.absolute_path('pages'))
  end
end
