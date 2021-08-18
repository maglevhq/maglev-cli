# frozen_string_literal: true

module Maglev
  module CLI
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
        inject_into_file 'config/routes.rb', before: /^end/ do
          <<-TEXT
  # [MAGLEV] For more information, go to https://doc.maglev.dev
  # [MAGLEV] Editor UI + preview endpoint
  mount Maglev::Pro::Engine => '/maglev', as: :maglev
  
  # [MAGLEV] CMS
  get '(*path)', to: 'maglev/page_preview#index', defaults: { path: 'index' }
          TEXT
        end
      end

      desc 'Maglev config lives at config/initialisers/maglev.rb'
      def config
        directory 'config'
      end

      desc 'Maglev default image placeholder'
      def config
        directory 'public'
      end
    end
  end
end
