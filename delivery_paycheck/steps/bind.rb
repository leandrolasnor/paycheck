# frozen_string_literal: true

class Bind
  include Dry::Monads[:result, :try]
  extend  Dry::Initializer

  option :reader, default: -> { PDF::Reader }

  def call(paths_to_paychecks:, people_list:, **params)
    res = Try do
      bar = Progress.register("Anexando os arquivos [:bar] :percent", total: paths_to_paychecks.count)
      ths = paths_to_paychecks.map do |path|
        Thread.new do
          bar.advance
          pdf_file = reader.new(path)
          paycheck_content = content(pdf_file)

          index = people_list.find_index do
            paycheck_content.scan(/#{_1.name}|#{_1.position}/).present?
          end

          next if index.nil?
          person = people_list.delete_at(index)
          person.paycheck_file_path = path
          person
        end
      end

      ths.map(&:value)
    end

    res.failure? ? Failure(res.exception) : Success(params.merge(people_list: res.value!.compact))
  end

  private

  def content(pdf_file)
    res = Try { pdf_file.pages.last.text }

    res.failure? ? Failure(res.exception) : res.value!
  end
end
