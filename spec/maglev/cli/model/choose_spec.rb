# frozen_string_literal: true

require 'spec_helper'
require 'tty/prompt'
require 'maglev/cli/model'
require 'maglev/cli/model/choose'

RSpec.describe Maglev::CLI::Model::Choose do
  let(:chosen_model) { Maglev::CLI::Model.new(name: 'User', path: 'app/models/user.rb') }
  let(:prompt) { instance_double(TTY::Prompt) }
  let(:choices) { [{ name: chosen_model.name, value: chosen_model }] }

  before do
    allow(prompt).to receive(:select).with('Which model will own a Maglev site?', choices).and_return chosen_model
  end

  subject { described_class.call(models: [chosen_model], prompt: prompt) }

  it { is_expected.to eq(chosen_model) }
end
