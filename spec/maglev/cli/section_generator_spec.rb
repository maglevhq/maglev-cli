# frozen_string_literal: true

require 'spec_helper'
require 'thor'
require 'fileutils'
require 'maglev/cli/install_generator'
require 'maglev/cli/theme_generator'
require 'maglev/cli/section_generator'

RSpec.describe Maglev::CLI::SectionGenerator do
  before(:all) do
    FileUtils.remove_dir(TMP_PATH) if File.exist?(TMP_PATH)
    FileUtils.cp_r(DUMMY_PATH, TMP_PATH)
    Dir.chdir(TMP_PATH) do
      Maglev::CLI::InstallGenerator.start
    end
  end
  after(:all) { FileUtils.remove_dir(TMP_PATH) if File.exist?(TMP_PATH) }

  subject do
    Dir.chdir(TMP_PATH) do
      described_class.start(['hero_01', *options])
    end
  end

  context 'there are no defined themes in the app' do
    let(:options) { [] }
    it 'raises an error' do
      expect { subject }.to raise_error(Thor::Error)
    end
  end

  context 'themes are present' do
    before(:each) do
      Dir.chdir(TMP_PATH) do
        Maglev::CLI::ThemeGenerator.start(['basic'])
      end
    end
    
    let(:options) { ["--theme", "basic", "--category", "hero", "--settings", "title", "body", "intro"] }

    it 'generates the definition YAML file' do
      subject
      path = 'app/themes/basic/sections/hero/hero_01.yml'
      Dir.chdir(TMP_PATH) do
        expect(File.file?(path)).to be true
        expect(File.read(path)).to include 'title:'
      end
    end

    it 'generates the view HTML/ERB file' do
      subject      
      Dir.chdir(TMP_PATH) do
        expect(File.file?('app/views/themes/basic/sections/hero/hero_01.html.erb')).to be true
      end
    end    
  end
end
