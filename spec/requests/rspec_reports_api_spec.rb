# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RspecReports', :rspec_reports_api, type: :request do
  before do
    FactoryBot.create(:tester,
                      name: 'user',
                      email: 'test@mailinator.com',
                      password: 'Qwerty12')
    project = FactoryBot.create(:project, project_name: 'Web App')
    rspec_report = FactoryBot.create(:rspec_report,
                                     version: '1.0.0',
                                     summary_line: '8 examples, 0 failures')
    FactoryBot.create(:report,
                      project_id: project.id,
                      reportable_type: RspecReport,
                      reportable_id: rspec_report.id,
                      status: 'passed',
                      tags: %w[High Full])
    FactoryBot.create(:rspec_summary,
                      rspec_report_id: rspec_report.id,
                      example_count: 53,
                      failure_count: 0,
                      pending_count: 2)
  end
  let(:tester) { Tester.first }
  let(:rspec_report) { RspecReport.first }

  describe 'GET index' do
    it 'is not authorized without X-API-KEY' do
      get '/api/v1/reports/rspec'
      expect(response.status).to eq(401)
    end

    it 'gets all rspec reports' do
      get '/api/v1/reports/rspec', headers: {
        'X-API-KEY' => tester.api_key
      }
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('rspec_report')
    end

    it 'filters rspec reports by tags' do
      get '/api/v1/reports/rspec?tags[]=High', headers: {
        'X-API-KEY' => tester.api_key
      }
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('rspec_report')
    end
  end

  describe 'GET show' do
    it 'is not authorized without X-API-KEY' do
      get "/api/v1/reports/rspec/#{rspec_report.id}"
      expect(response.status).to eq(401)
    end

    it 'shows an rspec report' do
      get "/api/v1/reports/rspec/#{rspec_report.id}", headers: {
        'X-API-KEY' => tester.api_key
      }
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('rspec_report')
    end
  end
end
