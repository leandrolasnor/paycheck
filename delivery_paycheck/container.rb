# frozen_string_literal: true

require 'dry/container'
Dir['./delivery_paycheck/steps/*.rb'].each { require _1 }

class Container
  extend Dry::Container::Mixin

  register 'steps.slice_paycheck', -> { SlicePaycheck.new }
  register 'steps.bind', -> { Bind.new }
  register 'steps.send_emails', -> { SendEmails.new }

end
