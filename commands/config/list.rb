# frozen_string_literal: true

class ListConfigCommand < Dry::CLI::Command
  extend Dry::Initializer

  option :config, default: -> { YAML.load_file('./config.yml') }

  def call
    puts config.to_yaml.to_s
  end
end