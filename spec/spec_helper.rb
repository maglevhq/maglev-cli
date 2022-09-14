# frozen_string_literal: true

# Force THOR to raise an error instead of doing a system exit
ENV['THOR_DEBUG'] = '1'

require 'bundler/setup'
require 'maglev/cli'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

ROOT_PATH  = File.join(File.dirname(__FILE__), '..')
DUMMY_PATH = File.join(File.dirname(__FILE__), 'fixtures', 'dummy')
TMP_PATH   = File.join(ROOT_PATH, 'tmp', 'dummy')
