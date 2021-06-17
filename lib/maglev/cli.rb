# frozen_string_literal: true

require 'thor'
require 'bundler/cli'

module Maglev
  # The main CLI entrypoint
  class CLI < Thor
    desc 'setup', 'Run this in a Rails app folder to set up Maglev'
    def setup
      require_relative 'cli/setup'
      Maglev::CLI::Setup.start
    end
  end
end
