# frozen_string_literal: true

require_relative 'install_generator'
require_relative 'model/find'
require_relative 'model/choose'

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
        return if @uploader ||= uploader_in_gemfile

        abort('Please install an uploader in your Rails application.')
      end

      def add_dependency
        insert_into_file 'Gemfile', "gem 'maglev-rails-engine'\n"
      end

      def bundle_install
        Bundler::CLI.start(%w[install])
      end

      def inject_association_macro
        return unless (parent_model = ask_for_parent_model)

        inject_into_class(parent_model.path, parent_model.name) do
          "  has_one_maglev_site\n"
        end
      end

      def install_generator
        Maglev::CLI::InstallGenerator.start
      end

      def migrate
        Kernel.system('rails maglev:install:migrations db:migrate')
      end

      private

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
end
