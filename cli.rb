# frozen_string_literal: true

require 'dry/transaction'
require 'dry/initializer'
require 'tty-progressbar'
require 'dry/validation'
require 'dry/container'
require 'combine_pdf'
require 'dry/monads'
require 'pdf/reader'
require 'key_path'
require 'dry/cli'
require 'ostruct'
require 'yaml'
require 'pry'
require 'csv'

Dir['./commands/**/*.rb'].each { require _1 }
Dir['./contracts/**/*.rb'].each { require _1 }

Config = YAML.load_file('./config.yml').deep_symbolize_keys

module CLI
  extend Dry::CLI::Registry

  register 'config' do |prefix|
    prefix.register '-m', UpdateConfigCommand
    prefix.register '-l', ListConfigCommand
  end

  register 'people' do |prefix|
    prefix.register '-l', ListPeopleCommand
  end

  register 'deliver', PaycheckDeliver
end

Dry::CLI.new(CLI).call
