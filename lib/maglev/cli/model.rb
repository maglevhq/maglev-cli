# frozen_string_literal: true

module Maglev
  class CLI < Thor
    Model = Struct.new(:name, :path, keyword_init: true)
  end
end
