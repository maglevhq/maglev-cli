# frozen_string_literal: true

module Maglev
  class CLI
    # Generates a maglev theme.
    class ThemeGenerator < Thor::Group
      include Thor::Actions

      argument :name

      def self.source_root
        File.expand_path('templates/theme', __dir__)
      end

      def create_theme_files
        directory 'app'
      end
    end
  end
end
