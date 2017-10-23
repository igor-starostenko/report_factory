# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RspecSummary, :rspec_summary, type: :model do
  let :rspec_report do
    FactoryBot.create(:rspec_report,
                      version: '1.0.0',
                      summary_line: '8 examples, 0 failures')
  end
  let :rspec_summary do
    FactoryBot.create(:rspec_summary,
                      rspec_report_id: rspec_report.id,
                      duration: 0.019803,
                      example_count: 8,
                      failure_count: 1,
                      pending_count: 0,
                      errors_outside_of_examples_count: 0)
  end

  it 'is valid' do
    expect(rspec_summary).to be_valid
  end

  it 'is not valid without :rspec_report_id' do
    rspec_summary.rspec_report_id = nil
    expect(rspec_summary).to_not be_valid
  end

  it 'is valid without :duration' do
    rspec_summary.duration = nil
    expect(rspec_summary).to be_valid
  end

  it 'is not valid without :example_count' do
    rspec_summary.example_count = nil
    expect(rspec_summary).to_not be_valid
  end

  it 'is not valid without :failure_count' do
    rspec_summary.failure_count = nil
    expect(rspec_summary).to_not be_valid
  end

  it 'is not valid without :pending_count' do
    rspec_summary.pending_count = nil
    expect(rspec_summary).to_not be_valid
  end

  it 'is valid without :errors_outside_of_examples_count' do
    rspec_summary.errors_outside_of_examples_count = nil
    expect(rspec_summary).to be_valid
  end

  it 'belongs to one :rspec_report' do
    expect(rspec_summary.rspec_report).to be_instance_of(RspecReport)
    expect(rspec_summary.rspec_report.id).to eq(rspec_report.id)
  end

  it 'is not valid if :rspec_report_id is not unique' do
    rspec_summary.save
    expect(RspecSummary.new(rspec_report_id: rspec_report.id,
                            example_count: 8,
                            failure_count: 1,
                            pending_count: 0)).to_not be_valid
  end
end
