# frozen_string_literal: true

require './delivery_paycheck/transaction.rb'

class PaycheckDeliver < Dry::CLI::Command
  extend Dry::Initializer

  option :progress_bar, default: -> { TTY::ProgressBar::Multi.new("Delivery Paycheck [:bar] :percent", bar_format: :box, incomplete: " ") }
  option :person_struct, default: -> { Struct.new(:name, :position, :email, :paycheck_file_path) }
  option :people_file_path, default: -> { Config[:paycheck][:people_file_path] }
  option :options, default: -> { { headers: true, col_sep: "\t", liberal_parsing: true, header_converters: :symbol } }
  option :people_list, default: -> { CSV.foreach(people_file_path, **options).map { person_struct.new(**_1.to_h) } }
  option :transaction, default: -> { Transaction.new }

  def call
    transaction.subscribe(slice: SlicePaycheckListener)
    transaction.subscribe(bind: BindListener)
    transaction.subscribe(send_emails: SendEmailsListener)
    transaction.operations[:slice].subscribe('paycheck.fork') { $slicer_bar.advance }
    transaction.operations[:bind].subscribe('paycheck.bound') { $binder_bar.advance }
    transaction.operations[:send_emails].subscribe('paycheck.sended') { $sender_bar.advance }

    transaction.(people_list: people_list) do
      _1.failure do |e|
        puts e.message
      end

      _1.success do
        puts 'Processo concluído'
      end
    end
  end
end
