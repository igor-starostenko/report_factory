# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MochaReports', :mocha_reports_api, type: :request do
  before do
    FactoryBot.create(:tester,
                      name: 'user',
                      email: 'test@mailinator.com',
                      password: 'Qwerty12')
    project = FactoryBot.create(:project, project_name: 'Web App')
    mocha_report = FactoryBot.create(:mocha_report,
                                     suites: 2,
                                     total: 2,
                                     passes: 1,
                                     pending: 0,
                                     failures: 1,
                                     duration: 8,
                                     started: '2019-01-20T04:28:34.861Z',
                                     ended: '2019-01-20T04:28:34.867Z')
    FactoryBot.create(:report,
                      project_id: project.id,
                      reportable_type: MochaReport,
                      reportable_id: mocha_report.id,
                      status: 'failed',
                      tags: %w[High Full])
  end
  let(:tester) { Tester.first }
  let(:mocha_report) { MochaReport.first }

  describe 'GET index' do
    it 'is not authorized without X-API-KEY' do
      get '/api/v1/reports/mocha'
      expect(response.status).to eq(401)
    end

    it 'gets all mocha reports' do
      get '/api/v1/reports/mocha', headers: {
        'X-API-KEY' => tester.api_key
      }
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('mocha_report')
    end

    it 'filters mocha reports by tags' do
      get '/api/v1/reports/mocha?tags[]=High', headers: {
        'X-API-KEY' => tester.api_key
      }
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('mocha_report')
    end
  end

  describe 'GET show' do
    it 'is not authorized without X-API-KEY' do
      get "/api/v1/reports/mocha/#{mocha_report.id}"
      expect(response.status).to eq(401)
    end

    it 'shows a mocha report' do
      get "/api/v1/reports/mocha/#{mocha_report.id}", headers: {
        'X-API-KEY' => tester.api_key
      }
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('mocha_report')
    end
  end
end
