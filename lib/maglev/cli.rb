# frozen_string_literal: true

require 'thor'
require 'bundler/cli'

module Maglev
  # The main CLI entrypoint
  class CLI < Thor
    VERSION = '0.1.0'
    include Thor::Actions

    desc 'maglev setup', 'Run this in a Rails app folder to set up Maglev'
    def setup
      insert_into_file 'Gemfile', "gem 'maglev-rails-engine'"
      Bundler::CLI.start(%w[install])
      Kernel.system('rails g maglev:install')
      Kernel.system('rails maglev:install:migrations db:migrate')
    end
  end
end
