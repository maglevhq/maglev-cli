# frozen_string_literal: true

require 'tty/prompt'

module Maglev
  module CLI
    class Model
      # Asks the user to select a model using a TTY Prompt
      module Choose
        def self.call(prompt: TTY::Prompt.new, models:)
          prompt.select('Which model will have maglev sites?', choices(models))
        end

        def self.choices(models)
          models.map { |model| { name: model.name, value: model } }
        end
      end
    end
  end
end
