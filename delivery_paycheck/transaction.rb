# frozen_string_literal: true

require 'dry/initializer'
require 'dry/transaction'
require './delivery_paycheck/container.rb'

class Transaction
  include Dry::Transaction(container: ::Container)

  tee :params
  step :slice, with: 'steps.slice_paycheck'
  step :bind, with: 'steps.bind'
  step :send_emails, with: 'steps.send_emails'

  private

  def params(input) end
end
