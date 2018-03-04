# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RspecReport, :rspec_report, type: :model do
  let :rspec_report do
    FactoryBot.create(:rspec_report,
                      version: '1.0.0',
                      summary_line: '8 examples, 0 failures')
  end

  it 'is valid' do
    expect(rspec_report).to be_valid
  end

  it 'is valid without :version' do
    rspec_report.version = nil
    expect(rspec_report).to be_valid
  end

  it 'is valid without :summary_line' do
    rspec_report.summary_line = nil
    expect(rspec_report).to be_valid
  end

  it 'can by filtered by report tags' do
    relation = described_class.tags('High')
    expect(relation.class.to_s).to eql('RspecReport::ActiveRecord_Relation')
  end
end
