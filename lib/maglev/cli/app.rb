# frozen_string_literal: true

require 'thor'
require 'bundler/cli'

module Maglev
  module CLI
    # The main CLI entrypoint
    class App < Thor
      desc 'setup', 'Run this in a Rails app folder to set up Maglev'
      def setup
        require_relative './setup'
        Maglev::CLI::Setup.start
      end

      desc 'theme NAME', 'Generate a maglev Theme'
      def theme(name)
        require_relative './theme_generator'
        Maglev::CLI::ThemeGenerator.start([name])
      end

      desc 'section NAME [GENERATOR_OPTIONS]', 'Generate a maglev Section'
      def section(name, *generator_options)
        require_relative './section_generator'
        Maglev::CLI::SectionGenerator.start([name, *generator_options])
      end

      def self.exit_on_failure?
        true
      end
    end
  end
end