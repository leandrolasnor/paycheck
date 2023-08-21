# frozen_string_literal: true

class Bind
  include Dry::Monads[:result]
  include Dry::Events::Publisher[:binder]
  extend  Dry::Initializer

  option :reader, default: -> { PDF::Reader }

  register_event 'paycheck.bound'

  def call(paths_to_paychecks:, people_list:, **params)
    people_list = paths_to_paychecks.map do |path|
      paycheck_content = reader.new(path).pages.last.text

      index = people_list.find_index do
        paycheck_content.scan(/#{_1.name}|#{_1.position}/).count == 2
      end
      next if index.nil?

      person = people_list.delete_at(index)
      publish('paycheck.bound', person: person)

      person.paycheck_file_path = path
      person
    end

    params.merge(people_list: people_list)
  end
end
