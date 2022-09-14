# frozen_string_literal: true

require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext/string'
require 'yaml'

module Maglev
  module CLI
    class SectionGenerator < Thor::Group
      include Thor::Actions

      class_option :theme, type: :string, default: nil
      class_option :category, type: :string, default: nil
      class_option :settings, type: :array, default: []
      argument :section_name, type: :string

      attr_reader :file_name, :theme_name, :category, :settings, :blocks

      def self.source_root
        File.expand_path('templates/section', __dir__)
      end

      def set_file_name
        @file_name = section_name.underscore
      end

      def verify_themes_are_present
        raise Thor::Error, set_color('ERROR: You must first create a theme.', :red) if themes.empty?
      end

      def select_theme
        @theme_name = options['theme']
        if @theme_name.blank?
          say 'You have to select a theme', :blue
          @theme_name = ask 'Please choose a theme', limited_to: themes, default: themes.first
        end
      end

      def select_category
        @category = options['category']
        return if @category.present?
        say 'You have to select a category', :blue
        @category = ask 'Please choose a category', limited_to: categories, default: categories.first
      end

      def build_settings
        @settings = extract_section_settings
        @blocks = extract_blocks
      end

      def create_section_files
        directory 'app'
      end

      private

      def themes
        @themes ||= Dir.chdir('app/themes') do
          Dir.glob('*').select { |f| File.directory? f }
        end
      end

      def categories
        YAML.load_file("./app/themes/#{theme_name}/theme.yml")['section_categories']
        .map do |category|
          category['id'] || category['name'].parameterize(separator: '_')
        end        
      end

      def extract_section_settings
        # build section settings only
        options['settings'].map do |raw_setting|
          next if raw_setting.starts_with?('block:') # block setting

          id, type = raw_setting.split(':')
          SectionSetting.new(id, type)
        end.compact.presence || default_section_settings
      end

      def extract_blocks
        # build block settings
        blocks = options['settings'].map do |raw_setting|
          next unless raw_setting.starts_with?('block:') # block setting

          _, block_type, id, type = raw_setting.split(':')
          BlockSetting.new(block_type, id, type)
        end.compact.presence || []

        blocks = default_block_settings if blocks.blank?

        # group them by block types
        blocks.group_by(&:block_type)
      end

      def default_section_settings
        [
          SectionSetting.new('title', 'text', 'My awesome title'),
          SectionSetting.new('image', 'image', 'An image')
        ]
      end

      def default_block_settings
        [
          BlockSetting.new('list_item', 'title', 'text', 'Item title'),
          BlockSetting.new('list_item', 'image', 'image', 'Item image')
        ]
      end

      class SectionSetting
        attr_reader :id, :type, :label

        def initialize(id, type, label = nil)
          @id = id
          @type = type || 'text'
          @label = label || id.humanize
        end

        def default
          case type
          when 'text' then label
          when 'image' then '"/themes/image-placeholder.jpg"'
          when 'checkbox' then true
          when 'link' then '"#"'
          when 'color' then '#E5E7EB'
          when 'radio', 'select' then 'option_1'

          end
        end

        def value?
          !%w[hint content_type].include?(type)
        end
      end

      class BlockSetting < SectionSetting
        attr_reader :block_type

        def initialize(block_type, id, type, label = nil)
          super(id, type, label)
          @block_type = block_type
        end
      end
    end
  end
end
