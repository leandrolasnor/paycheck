module SlicePaycheckListener
  extend self

  def on_step(e)
    paycheck_file = CombinePDF.load(Config[:paycheck][:paycheck_file_path])
    $slicer_bar = ProgressBar.register("Separando os arquivos [:bar] :percent", total: paycheck_file.pages.size)
  end
end