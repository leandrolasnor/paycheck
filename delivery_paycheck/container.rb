# frozen_string_literal: true

class Container
  extend Dry::Container::Mixin

  register 'steps.slice_paycheck', -> { SlicePaycheck.new }
  register 'steps.bind', -> { Bind.new }
  register 'steps.send_emails', -> { SendEmails.new }

end
