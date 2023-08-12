# frozen_string_literal: true

Progress = TTY::ProgressBar::Multi.new("Paycheck Deliver  [:bar] :percent")

class Container
  extend Dry::Container::Mixin

  register 'steps.slice_paycheck', -> { SlicePaycheck.new }
  register 'steps.bind', -> { Bind.new }
  register 'steps.send_emails', -> { SendEmails.new }

end
