# frozen_string_literal: true

require_relative '../model'

module Maglev
  module CLI
    class Model
      module Find
        def self.call(application_path:)
          Dir.chdir(File.join(application_path, 'app', 'models')) do
            Dir.glob('**/*.rb').reject(&method(:reject)).map(&method(:format))
          end
        end

        def self.reject(entry)
          entry == 'application_record.rb' || entry.start_with?('concerns/')
        end

        def self.format(entry)
          Maglev::CLI::Model.new(
            name: classify(entry.delete_suffix('.rb')),
            path: "app/models/#{entry}"
          )
        end

        def self.classify(name)
          name.split('/').map(&:capitalize).join('::').split('_').map { |word| word.sub(/^./, &:upcase) }.join
        end
      end
    end
  end
end
