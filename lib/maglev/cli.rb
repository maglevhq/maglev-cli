# frozen_string_literal: true

require 'thor'
require 'bundler/cli'
require_relative 'cli/model/find'
require_relative 'cli/model/choose'
require_relative 'cli/install_generator'

module Maglev
  # The main CLI entrypoint
  class CLI < Thor
    VERSION = '0.1.0'
    include Thor::Actions

    desc 'setup', 'Run this in a Rails app folder to set up Maglev'
    def setup
      verify_gemfile_lock!
      verify_uploader!
      insert_into_file 'Gemfile', "gem 'maglev-rails-engine'"
      Bundler::CLI.start(%w[install])
      if (parent_model = ask_for_parent_model)
        inject_into_class(parent_model.path, parent_model.name) do
          "  has_one_maglev_site\n"
        end
      end
      Maglev::CLI::InstallGenerator.start
      Kernel.system('rails maglev:install:migrations db:migrate')
    end

    private

    def verify_gemfile_lock!
      return if File.file?('Gemfile.lock')

      abort('Gemfile.lock not found.')
    end

    def verify_uploader!
      return if @uploader ||= uploader_in_gemfile

      abort('Please install an uploader in your Rails application.') 
    end

    def uploader_in_gemfile
      File.foreach('Gemfile.lock') do |line|
        return 'activestorage' if line =~ /activestorage/
      end

      false
    end

    def ask_for_parent_model
      models = Maglev::CLI::Model::Find.call(application_path: Dir.pwd)
      return if models.empty?

      Maglev::CLI::Model::Choose.call(models: models)
    end
  end
end
