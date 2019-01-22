# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MochaReport, :mocha_report, type: :model do
  let :mocha_report do
    FactoryBot.create(:mocha_report,
                      suites: 2,
                      total: 2,
                      passes: 1,
                      pending: 0,
                      failures: 1,
                      duration: 8,
                      started: '2019-01-20T04:28:34.861Z',
                      ended: '2019-01-20T04:28:34.867Z')
  end

  it 'is valid' do
    expect(mocha_report).to be_valid
  end

  it 'is valid without :suites' do
    mocha_report.suites = nil
    expect(mocha_report).to be_valid
  end

  it 'is not valid without :total' do
    mocha_report.total = nil
    expect(mocha_report).to_not be_valid
  end

  it 'is not valid without :passes' do
    mocha_report.passes = nil
    expect(mocha_report).to_not be_valid
  end

  it 'is not valid without :pending' do
    mocha_report.pending = nil
    expect(mocha_report).to_not be_valid
  end

  it 'is not valid without :failures' do
    mocha_report.failures = nil
    expect(mocha_report).to_not be_valid
  end

  it 'is not valid without :duration' do
    mocha_report.duration = nil
    expect(mocha_report).to_not be_valid
  end

  it 'is valid without :start' do
    mocha_report.started = nil
    expect(mocha_report).to be_valid
  end

  it 'is valid without :end' do
    mocha_report.ended = nil
    expect(mocha_report).to be_valid
  end

  it 'can by filtered by report tags' do
    relation = described_class.tags('High')
    expect(relation.class.to_s).to eql('MochaReport::ActiveRecord_Relation')
  end
end
