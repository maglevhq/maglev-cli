# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'

RSpec.describe Maglev::CLI do
  it 'has a version number' do
    expect(Maglev::CLI::VERSION).not_to be nil
  end

  describe 'setup' do
    before(:all) do
      FileUtils.remove_dir(TMP_PATH) if File.exist?(TMP_PATH)
      FileUtils.mkdir_p(File.join(TMP_PATH, '..'))
      FileUtils.cp_r(DUMMY_PATH, File.join(TMP_PATH, '..'))
    end

    after(:all) { FileUtils.remove_dir(TMP_PATH) if File.exist?(TMP_PATH) }

    around do |example|
      Dir.chdir(TMP_PATH) do
        example.run
      end
    end

    let(:gemfile) { File.read(File.join(TMP_PATH, 'Gemfile')) }
    let(:user_model_file) { File.read(File.join(TMP_PATH, 'app', 'models', 'user.rb')) }
    let(:model) { Maglev::CLI::Model.new(name: 'User', path: 'app/models/user.rb') }

    subject { Maglev::CLI.start(%w[setup]) }

    it 'does all needed steps' do
      require 'thor'
      require 'maglev/cli/setup'
      
      expect(Bundler::CLI).to receive(:start).with(%w[install]).ordered
      expect(Maglev::CLI::InstallGenerator).to receive(:start).ordered
      expect(Kernel).to receive(:system).with('rails maglev:webpacker:compile')
      expect(Kernel).to receive(:system).with('rails maglev_pro:install:migrations db:migrate').ordered
      allow(Maglev::CLI::Model::Choose).to receive(:call).and_return(model)
      expect { subject }.not_to raise_error
      expect(gemfile).to include("gem 'maglev-pro'")
      expect(user_model_file).to include(
        <<-MODEL
class User < ApplicationRecord
  has_one :maglev_site, class_name: 'Maglev::Site', as: :siteable, dependent: :destroy
end
        MODEL
      )
    end
  end
end
