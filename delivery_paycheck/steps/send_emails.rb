# frozen_string_literal: true

require './delivery_paycheck/paycheck_mailer.rb'

class SendEmails
  include Dry::Monads[:result, :try]
  extend Dry::Initializer

  option :mailer, default: -> { PaycheckMailer }

  def call(people_list:)
    res = Try do
      bar = Progress.register("Enviando os e-mails [:bar] :percent", total: people_list.count)
      ths = people_list.map do |p|
        Thread.new do
          delived = mailer.(email: p.email, paycheck_file_path: p.paycheck_file_path).deliver_now
          bar.advance
          delived
        end.join
      end

      ths.map(&:value)
    end

    res.failure? ? Failure(res.exception) : Success(res.value!)
  ensure
    FileUtils.remove_dir(File.absolute_path('pages'))
  end
end
