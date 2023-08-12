# frozen_string_literal: true

class PaycheckDeliver < Dry::CLI::Command
  extend Dry::Initializer

  option :config, default: -> { YAML.load_file('./config.yml').deep_symbolize_keys }
  option :person_struct, default: -> { Struct.new(:name, :position, :email, :paycheck_file_path) }
  option :options, default: -> { { headers: true, col_sep: "\t", liberal_parsing: true, header_converters: :symbol } }
  option :paycheck_file_path, default: -> { config[:paycheck][:paycheck_file_path] }
  option :people_file_path, default: -> { config[:paycheck][:people_file_path] }

  def call
    Transaction.new.(paycheck_file_path: paycheck_file_path, people_list: people_list, config: config) do
      _1.failure { |f| p f.message }
      _1.success { p 'ok' }
    end
  end

  private

  def people_list
    CSV.foreach(people_file_path, **options).map do
      person_struct.new(
        name: _1[:name],
        email: _1[:email],
        position: _1[:position]  
      )
    end
  end
end
