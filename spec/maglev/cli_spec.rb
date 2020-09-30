# frozen_string_literal: true

require 'spec_helper'
require 'maglev/cli'

DUMMY_PATH = File.join(File.dirname(__FILE__), '..', 'fixtures', 'dummy')
TMP_PATH   = File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'dummy')

RSpec.describe Maglev::CLI do
  it 'has a version number' do
    expect(Maglev::CLI::VERSION).not_to be nil
  end

  describe 'setup' do
    before(:all) do
      FileUtils.remove_dir(TMP_PATH) if File.exist?(TMP_PATH)
      FileUtils.cp_r(DUMMY_PATH, TMP_PATH)
      Dir.chdir('tmp/dummy')
    end

    let(:gemfile) { File.read(File.join(TMP_PATH, 'Gemfile')) }
    let(:user_model_file) { File.read(File.join(TMP_PATH, 'app', 'models', 'user.rb')) }
    let(:model) { Maglev::CLI::Model.new(name: 'User', path: 'app/models/user.rb') }

    subject { Maglev::CLI.start(%w[setup]) }

    it 'does all needed steps' do
      expect(Bundler::CLI).to receive(:start).with(%w[install]).ordered
      expect(Kernel).to receive(:system).with('rails g maglev:install').ordered
      expect(Kernel).to receive(:system).with('rails maglev:install:migrations db:migrate').ordered
      allow(Maglev::CLI::Model::Choose).to receive(:call).and_return(model)
      subject
      expect(gemfile).to include("gem 'maglev-rails-engine'")
      expect(user_model_file).to include('has_one_maglev_site')
    end
  end
end
