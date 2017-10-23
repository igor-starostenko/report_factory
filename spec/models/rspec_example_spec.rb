# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RspecExample, :rspec_example, type: :model do
  let :rspec_report do
    FactoryBot.create(:rspec_report,
                      version: '1.0.0',
                      summary_line: '8 examples, 0 failures')
  end
  let :spec_id { './spec/routing/reports_routes_spec.rb[1:3]' }
  let :description do
    'routes GET /api/v1/projects/:project_name/reports/:id to reports#show'
  end
  let :full_description { "routing to reports #{description}" }
  let :file_path { './spec/routing/reports_routes_spec.rb' }
  let :rspec_example do
    FactoryBot.create(:rspec_example,
                      rspec_report_id: rspec_report.id,
                      spec_id: spec_id,
                      description: description,
                      full_description: full_description,
                      status: 'passed',
                      file_path: file_path,
                      line_number: 20,
                      run_time: 0.000854,
                      pending_message: 'message')
  end

  it 'is valid' do
    expect(rspec_example).to be_valid
  end

  it 'is not valid without :rspec_report_id' do
    rspec_example.rspec_report_id = nil
    expect(rspec_example).to_not be_valid
  end

  it 'is valid without :spec_id' do
    rspec_example.spec_id = nil
    expect(rspec_example).to be_valid
  end

  it 'is valid without :description' do
    rspec_example.description = nil
    expect(rspec_example).to be_valid
  end

  it 'is valid without :full_description' do
    rspec_example.full_description = nil
    expect(rspec_example).to be_valid
  end

  it 'is not valid without :status' do
    rspec_example.status = nil
    expect(rspec_example).to_not be_valid
  end

  it 'is valid without :line_number' do
    rspec_example.line_number = nil
    expect(rspec_example).to be_valid
  end

  it 'is valid without :run_time' do
    rspec_example.run_time = nil
    expect(rspec_example).to be_valid
  end

  it 'is valid without :pending_message' do
    rspec_example.pending_message = nil
    expect(rspec_example).to be_valid
  end

  it 'belongs to one :rspec_report' do
    expect(rspec_example.rspec_report).to be_instance_of(RspecReport)
    expect(rspec_example.rspec_report.id).to eq(rspec_report.id)
  end
end
