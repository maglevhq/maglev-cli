# frozen_string_literal: true

require 'thor'
require 'bundler/cli'
require_relative 'cli/setup'

module Maglev
  # The main CLI entrypoint
  class CLI < Thor
    desc 'setup', 'Run this in a Rails app folder to set up Maglev'
    def setup
      Maglev::CLI::Setup.start
    end
  end
end
