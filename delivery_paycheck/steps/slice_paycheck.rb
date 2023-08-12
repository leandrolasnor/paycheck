# frozen_string_literal: true

class SlicePaycheck
  include Dry::Monads[:result, :try]
  extend  Dry::Initializer

  option :pdf, default: -> { CombinePDF }
  option :paycheck_file, default: -> { pdf.load(Config[:paycheck][:paycheck_file_path]) }
  option :pages_dir, default: -> { File.absolute_path('pages') }

  def call(**params)
    mkdir_pages
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
      bar = Progress.register("Separando os arquivos [:bar] :percent", total: paycheck_file.pages.count)
      ths = paycheck_file.pages.map.with_index(1) do |page, i|
        Thread.new do
          bar.advance
          slice(page, i)
        end
      end
      ths.map(&:value)
    end

    res.failure? ? Failure(res.exception) : res.value!
  end

  def slice(page, i)
    page_path = "#{pages_dir}/#{i}.pdf"
    sliced = pdf.new
    sliced << page
    sliced.save(page_path)
    page_path
  end
end
