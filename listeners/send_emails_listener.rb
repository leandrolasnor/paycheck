module SendEmailsListener
  extend self

  def on_step(e)
    people_list = e.payload[:args][0][:people_list]
    $sender_bar = ProgressBar.register("Enviando os e-mails [:bar] :percent", total: people_list.size)
  end
end