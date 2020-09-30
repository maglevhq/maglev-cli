# frozen_string_literal: true

require 'spec_helper'
require 'maglev/cli/model/find'

RSpec.describe Maglev::CLI::Model::Find do
  def model(args)
    Maglev::CLI::Model.new(args)
  end

  let(:dummy_path) { File.join(File.dirname(__FILE__), '..', '..', '..', 'fixtures', 'dummy') }
  subject { described_class.call(application_path: dummy_path) }

  it do
    is_expected.to contain_exactly(
      model(name: 'Invoice', path: 'app/models/invoice.rb'),
      model(name: 'User', path: 'app/models/user.rb'),
      model(name: 'NamespacedModels::NestedModel', path: 'app/models/namespaced_models/nested_model.rb')
    )
  end
end
