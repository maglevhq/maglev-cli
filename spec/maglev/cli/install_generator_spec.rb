# frozen_string_literal: true

require 'spec_helper'
require 'thor'
require 'fileutils'
require 'maglev/cli/install_generator'

RSpec.describe Maglev::CLI::InstallGenerator do
  let(:routes_file) { File.read('config/routes.rb') }
  let(:config_file) { File.read(File.join(TMP_PATH, 'config', 'initializers', 'maglev.rb')) }

  before(:all) do
    FileUtils.remove_dir(TMP_PATH) if File.exist?(TMP_PATH)
    FileUtils.cp_r(DUMMY_PATH, TMP_PATH)
    Dir.chdir(TMP_PATH) do
      described_class.start
    end
  end

  around(:each) do |example|
    Dir.chdir(TMP_PATH) do
      example.run
    end
  end

  after(:all) { FileUtils.remove_dir(TMP_PATH) if File.exist?(TMP_PATH) }

  it 'generates an app/themes directory' do
    expect(File.file?('app/themes/.keep')).to be true
  end

  it 'generates an app/views/themes directory' do
    expect(File.file?('app/views/themes/.keep')).to be true
  end

  it 'mounts the Maglev::Engine' do
    expect(routes_file).to include("mount Maglev::Pro::Engine => '/maglev', as: :maglev")
  end

  it 'adds a catch-all route' do
    expect(routes_file).to include("get '(*path)', to: 'maglev/page_preview#index', defaults: { path: 'index' }, constraints: Maglev::PreviewConstraint.new")
  end

  it 'copies maglev config' do
    expect(config_file).to include('uploader = :active_storage')
  end
end
