# frozen_string_literal: true

require './delivery_paycheck/transaction.rb'

class PaycheckDeliver < Dry::CLI::Command
  extend Dry::Initializer

  option :person_struct, default: -> { Struct.new(:name, :position, :email, :paycheck_file_path) }
  option :people_file_path, default: -> { Config[:paycheck][:people_file_path] }
  option :options, default: -> { { headers: true, col_sep: "\t", liberal_parsing: true, header_converters: :symbol } }
  option :people_list, default: -> { CSV.foreach(people_file_path, **options).map { person_struct.new(**_1.to_h) } }

  def call
    Transaction.new.(people_list: people_list) do
      _1.failure do |e|
        puts e.message
      end

      _1.success do
        puts 'Processo concluído'
      end
    end
  end
end
