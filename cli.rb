# frozen_string_literal: true

require 'dry/transaction'
require 'dry/initializer'
require 'dry/validation'
require 'dry/container'
require 'progress_bar'
require 'combine_pdf'
require 'dry/monads'
require 'pdf/reader'
require 'key_path'
require 'dry/cli'
require 'ostruct'
require 'yaml'
require 'pry'
require 'csv'

require './delivery_paycheck/transaction.rb'
Dir['./commands/**/*.rb'].each { require _1 }
Dir['./contracts/**/*.rb'].each { require _1 }

module CLI
  extend Dry::CLI::Registry

  register '-modify', aliases: ['-m'] do |prefix|
    prefix.register 'config', UpdateConfigCommand
  end

  register '-list', aliases: ['-l'] do |prefix|
    prefix.register 'people', ListPeopleCommand
    prefix.register 'config', ListConfigCommand
  end

  register 'deliver', PaycheckDeliver
end

Dry::CLI.new(CLI).call
