# frozen_string_literal: true

module Maglev
  class CLI
    # Generates a section within a Maglev theme.
    class SectionGenerator < Thor::Group
      include Thor::Actions

      def self.source_root
        File.expand_path('templates/section', __dir__)
      end

      argument :section_name

      attr_reader :theme_name

      def verify_themes_are_present
        raise Thor::Error, set_color('ERROR: You must first create a theme.', :red) if themes.empty?
      end

      def select_theme
        say 'You have to select a theme', :blue
        @theme_name = ask 'Please choose a theme', limited_to: themes, default: themes.first
      end

      def create_section_files
        directory 'app'
      end

      private

      def themes
        @themes ||= Dir.chdir('app/themes') do
          Dir.glob('*').select { |f| File.directory? f }
        end
      end
    end
  end
end
