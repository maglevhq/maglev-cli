# frozen_string_literal: true

module Maglev
  class CLI < Thor
    # Generates files needed by Maglev Engine
    class InstallGenerator < Thor::Group
      include Thor::Actions

      def self.source_root
        File.expand_path('templates/install', __dir__)
      end

      desc 'Configure necessary folders to use Maglev'
      def setup_themes_folder
        directory 'app/themes'
        directory 'app/views/themes'
      end

      desc 'Maglev has to catch all routes'
      def catch_all_routes
        append_to_file 'config/routes.rb', before: 'end' do
          <<~TEXT
            # For more information, go to https://doc.maglev.dev
            # [MAGLEV] editor UI + preview endpoint
            mount Maglev::Engine, at: '/maglev'
            # [MAGLEV] CMS
            get '(*path)', to: 'maglev/page_preview#index', defaults: { path: 'index' }"
          TEXT
        end
      end
    end
  end
end
