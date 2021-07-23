# frozen_string_literal: true

module Maglev
  module CLI
    def self.start(argv)
      require_relative 'cli/app'
      Maglev::CLI::App.start(argv)
    end
  end
end