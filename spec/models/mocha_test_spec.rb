# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MochaTest, :mocha_test, type: :model do
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
  let :spec_id do
    './spec/routing/reports_routes_spec.rb[1:3]'
  end
  let :title do
    'submits a passed test report to ReportFactory'
  end
  let :full_title do
    "ReportFactory API #{title}"
  end
  let :body do
    '() => {\n  return sendReport(report);\n}'
  end
  let :file do
    '/Users/username/ReportFactory/report-factory-mocha/test/api_test.js'
  end
  let :err do
    'ReferenceError: response is not defined\n (test/api_test.js:10:21) } ]'
  end
  let :mocha_test do
    FactoryBot.create(:mocha_test,
                      mocha_report_id: mocha_report.id,
                      title: title,
                      full_title: full_title,
                      body: body,
                      duration: 2,
                      status: 'failed',
                      speed: 'fast',
                      file: file,
                      timed_out: false,
                      pending: false,
                      sync: true,
                      async: 0,
                      current_retry: 0,
                      err: err)
  end

  it 'is valid' do
    expect(mocha_test).to be_valid
  end

  it 'is not valid without :mocha_report_id' do
    mocha_test.mocha_report_id = nil
    expect(mocha_test).to_not be_valid
  end

  it 'is valid without :title' do
    mocha_test.title = nil
    expect(mocha_test).to_not be_valid
  end

  it 'is valid without :full_title' do
    mocha_test.full_title = nil
    expect(mocha_test).to_not be_valid
  end

  it 'is valid without :body' do
    mocha_test.body = nil
    expect(mocha_test).to be_valid
  end

  it 'is not valid without :status' do
    mocha_test.status = nil
    expect(mocha_test).to_not be_valid
  end

  it 'is valid without :duration' do
    mocha_test.duration = nil
    expect(mocha_test).to be_valid
  end

  it 'is valid without :speed' do
    mocha_test.speed = nil
    expect(mocha_test).to be_valid
  end

  it 'is valid without :file' do
    mocha_test.file = nil
    expect(mocha_test).to be_valid
  end

  it 'is valid without :timed_out' do
    mocha_test.timed_out = nil
    expect(mocha_test).to be_valid
  end

  it 'is valid without :pending' do
    mocha_test.pending = nil
    expect(mocha_test).to be_valid
  end

  it 'is valid without :sync' do
    mocha_test.sync = nil
    expect(mocha_test).to be_valid
  end

  it 'is valid without :async' do
    mocha_test.async = nil
    expect(mocha_test).to be_valid
  end

  it 'is valid without :current_retry' do
    mocha_test.current_retry = nil
    expect(mocha_test).to be_valid
  end

  it 'is valid without :err' do
    mocha_test.err = nil
    expect(mocha_test).to be_valid
  end

  it 'belongs to one :mocha_test' do
    expect(mocha_test.mocha_report).to be_instance_of(MochaReport)
    expect(mocha_test.mocha_report.id).to eq(mocha_report.id)
  end
end
