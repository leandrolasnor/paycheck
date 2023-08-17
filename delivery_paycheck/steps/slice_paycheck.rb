# frozen_string_literal: true

class SlicePaycheck
  include Dry::Monads[:result]
  include Dry::Events::Publisher[:slicer]
  extend  Dry::Initializer

  option :pdf, default: -> { CombinePDF }
  option :paycheck_file, default: -> { pdf.load(Config[:paycheck][:paycheck_file_path]) }
  option :pages_dir, default: -> { File.absolute_path('pages') }

  register_event 'paycheck.fork'

  def call(**params)
    mkdir_pages
    paths_to_paychecks = slices(paycheck_file)

    params.merge(paths_to_paychecks: paths_to_paychecks)
  end

  private

  def mkdir_pages
    FileUtils.mkdir_p(pages_dir) unless File.directory?(pages_dir)
  end

  def slices(paycheck_file)
    paycheck_file.pages.map.with_index(1) do |page, i|
      sliced = pdf.new
      sliced << page
      sliced.save("#{pages_dir}/#{i}.pdf")

      publish('paycheck.fork', page: i)
      "#{pages_dir}/#{i}.pdf"
    end
  end
end
