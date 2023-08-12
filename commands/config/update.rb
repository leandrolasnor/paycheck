# frozen_string_literal: true

class UpdateConfigCommand < Dry::CLI::Command
  extend Dry::Initializer

  option :config, default: -> { YAML.load_file('./config.yml') }
  option :contract, default: -> { UpdateConfigContract.new }

  argument :path, required: true, desc: 'Path to key'
  argument :value, required: true, desc: 'Value to key'

  desc 'Updates the value from a given key path and value'
  def call(path:, value:)
    change = config.clone
    change.set_keypath(path, value)
    config.deep_merge!(change.deep_stringify_keys)
    res = contract.(config)
    return puts res.errors.to_h.to_yaml.to_s if res.failure?
    
    File.open('./config.yml', 'w') { YAML.dump(config, _1) }
    puts [path, config.value_at_keypath(path)]
  end
end
