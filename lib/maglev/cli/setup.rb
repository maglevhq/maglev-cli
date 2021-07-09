# frozen_string_literal: true

require_relative 'install_generator'
require_relative 'model/find'
require_relative 'model/choose'
require 'yaml'

module Maglev
  class CLI < Thor
    # CLI Setup as a Thor::Group class to improve readability
    class Setup < Thor::Group
      include Thor::Actions

      def verify_gemfile_lock
        return if File.file?('Gemfile.lock')

        abort('Gemfile.lock not found.')
      end

      def verify_uploader
        return if uploader_in_gemfile

        abort('Please install an uploader in your Rails application.')
      end

      def verify_postgres
        config = YAML.load_file('config/database.yml')
        return if config.all? { |_environment, v| v['adapter'] == 'postgresql' }

        abort('Maglev requires a postgres database connection.')
      end

      def add_dependency
        # Temporary use this branch because it solves a bug
        insert_into_file 'Gemfile', "gem 'injectable', github: 'Papipo/injectable', branch: 'override-with-class'\n"
        # The core line is temporary until we actually release the core gem
        insert_into_file 'Gemfile', "gem 'maglev', github: 'maglevhq/maglev-core', branch: 'master', require: false\n"
        insert_into_file 'Gemfile', "gem 'maglev-pro', github: 'maglevhq/maglev-pro', branch: 'master', require: 'maglev/pro'\n"
      end

      def bundle_install
        Bundler::CLI.start(%w[install])
      end

      def setup_webpacker
        Kernel.system 'rails webpacker:install'
        Kernel.system 'maglev:webpacker:compile'
      end

      def inject_association_macro
        return unless (parent_model = ask_for_parent_model)

        inject_into_class parent_model.path, parent_model.name, <<~CODE
          has_one :maglev_site, as: :siteable, dependent: :destroy
        CODE
      end

      def install_generator
        Maglev::CLI::InstallGenerator.start
      end

      def migrate
        Kernel.system('rails maglev:install:migrations db:migrate')
        Kernel.system('rails maglev_pro:install:migrations db:migrate')
      end

      def instructions
        $stdout.puts <<~INFO
          Done! 🚅

          You can now tweak /config/initializers/maglev.rb.
          You also should:
            - Generate a theme with `maglev theme NAME`
            - Generate a section with `maglev section NAME`
          
          In your app, you can use `Maglev::Pro::GenerateSite.call` to generate
          a maglev site and attach it to your `siteable` model.

        INFO
      end

      private

      def uploader_in_gemfile
        @uploader_in_gemfile = File.foreach('Gemfile.lock') do |line|
          return 'activestorage' if line =~ /activestorage/
        end
      end

      def ask_for_parent_model
        models = Maglev::CLI::Model::Find.call(application_path: Dir.pwd)
        return if models.empty?

        Maglev::CLI::Model::Choose.call(models: models)
      end
    end
  end
end
