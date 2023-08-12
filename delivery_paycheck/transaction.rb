# frozen_string_literal: true

Dir['./delivery_paycheck/steps/*.rb'].each { require _1 }
require './delivery_paycheck/container.rb'

class Transaction
  include Dry::Transaction(container: ::Container)

  tee :params
  step :slice, with: 'steps.slice_paycheck'
  step :bind, with: 'steps.bind'
  step :send_emails, with: 'steps.send_emails'

  private

  def params(input)
    Progress.start
  end
end
