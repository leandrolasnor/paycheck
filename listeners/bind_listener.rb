module BindListener
  extend self

  def on_step(e)
    paths_to_paychecks = e.payload[:args][0][:paths_to_paychecks]
    $binder_bar = ProgressBar.register("Anexando os arquivos [:bar] :percent", total: paths_to_paychecks.size)
  end
end