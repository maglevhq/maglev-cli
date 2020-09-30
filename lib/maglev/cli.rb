# frozen_string_literal: true

require 'thor'
require 'bundler/cli'
require_relative 'cli/model/find'
require_relative 'cli/model/choose'

module Maglev
  # The main CLI entrypoint
  class CLI < Thor
    VERSION = '0.1.0'
    include Thor::Actions

    desc 'setup', 'Run this in a Rails app folder to set up Maglev'
    def setup
      insert_into_file 'Gemfile', "gem 'maglev-rails-engine'"
      Bundler::CLI.start(%w[install])
      if (parent_model = ask_for_parent_model)
        inject_into_class(parent_model.path, parent_model.name) do
          'has_one_maglev_site'
        end
      end
      Kernel.system('rails g maglev:install')
      Kernel.system('rails maglev:install:migrations db:migrate')
    end

    private

    def ask_for_parent_model
      models = Maglev::CLI::Model::Find.call(application_path: Dir.pwd)
      return if models.empty?

      Maglev::CLI::Model::Choose.call(models: models)
    end
  end
end
