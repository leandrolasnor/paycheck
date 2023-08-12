# frozen_string_literal: true

class SlicePaycheck
  include Dry::Monads[:result, :try]
  extend  Dry::Initializer

  option :pdf, default: -> { CombinePDF }
  option :pages_dir, default: -> { File.absolute_path('pages') }

  def call(paycheck_file_path:, **params)
    mkdir_pages
    paycheck_file = load(paycheck_file_path)
    paths_to_paychecks = slices(paycheck_file)

    Success(params.merge(paths_to_paychecks: paths_to_paychecks))
  end

  private

  def mkdir_pages
    res = Try { FileUtils.mkdir_p(pages_dir) unless File.directory?(pages_dir) }

    Failure(res.exception) if res.failure?
  end

  def slices(paycheck_file)
    res = Try do
      paycheck_file.pages.map.with_index(1) do
        page_path = "#{pages_dir}/#{_2}.pdf"

        sliced = pdf.new
        sliced << _1
        sliced.save(page_path)

        page_path
      end
    end

    res.failure? ? Failure(res.exception) : res.value!
  end

  def load(paycheck_file_path)
    res = Try { pdf.load(paycheck_file_path) }

    res.failure? ? Failure(res.exception) : res.value!
  end
end
