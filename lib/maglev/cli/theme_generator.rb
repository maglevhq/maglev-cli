# frozen_string_literal: true

require 'active_support/inflector'

module Maglev
  module CLI
    # Generates a maglev theme.
    class ThemeGenerator < Thor::Group
      include Thor::Actions

      argument :name

      attr_reader :file_name

      def self.source_root
        File.expand_path('templates/theme', __dir__)
      end

      def set_file_name
        @file_name = name.underscore
      end

      def create_theme_files
        directory 'app'
      end
    end
  end
end
