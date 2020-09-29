# frozen_string_literal: true

require 'spec_helper'

pp GEMFILE_PATH = File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'Gemfile')

RSpec.describe Maglev::CLI do
  def gemfile
    File.read(GEMFILE_PATH)
  end

  def clean
    File.delete(GEMFILE_PATH) if File.exist?(GEMFILE_PATH)
  end

  it 'has a version number' do
    expect(Maglev::CLI::VERSION).not_to be nil
  end

  describe 'setup' do
    before(:all) do
      clean
      Dir.chdir('tmp')
      File.open('Gemfile', 'w').close
    end

    after(:all) { clean } 

    subject { Maglev::CLI.start(%w[setup]) }

    it 'does all needed steps' do
      expect(Bundler::CLI).to receive(:start).with(%w[install]).ordered
      expect(Kernel).to receive(:system).with('rails g maglev:install').ordered
      expect(Kernel).to receive(:system).with('rails maglev:install:migrations db:migrate').ordered
      subject
      expect(gemfile).to include("gem 'maglev-rails-engine'")
    end
  end
end
