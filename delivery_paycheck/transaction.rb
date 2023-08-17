# frozen_string_literal: true

Dir['./delivery_paycheck/steps/*.rb'].each { require _1 }
require './delivery_paycheck/container.rb'

class Transaction
  include Dry::Transaction(container: ::Container)

  tee :params
  try :slice, with: 'steps.slice_paycheck', catch: StandardError
  try :bind, with: 'steps.bind', catch: StandardError
  try :send_emails, with: 'steps.send_emails', catch: StandardError

  private

  def params(input) end
end
