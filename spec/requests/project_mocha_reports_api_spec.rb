# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ProjectMochaReports', :project_mocha_reports_api,
               type: :request do
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
                                     duration: 8)
    FactoryBot.create(:report,
                      project_id: project.id,
                      tags: %w[High Full],
                      reportable_type: MochaReport,
                      reportable_id: mocha_report.id,
                      status: 'failed')
  end
  let(:tester) { Tester.first }
  let(:mocha_report) { MochaReport.first }

  describe 'GET index' do
    it 'is not authorized without X-API-KEY' do
      get '/api/v1/projects/web-app/reports/mocha'
      expect(response.status).to eq(401)
    end

    it 'gets all mocha reports within project' do
      get '/api/v1/projects/web-app/reports/mocha', headers: {
        'X-API-KEY' => tester.api_key
      }
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('mocha_report')
    end

    it 'filters mocha reports by tags within project' do
      get '/api/v1/projects/web-app/reports/mocha?tags[]=Full&tags[]=High',
          headers: {
            'X-API-KEY' => tester.api_key
          }
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('mocha_report')
    end
  end

  describe 'POST create' do
    let(:request_body) do
      {
        data: {
          type: 'mocha_report',
          attributes: {
            "suites":2,
            "tests":[
              {
                "title": "submits a failed test report",
                "fullTitle": "ReportFactory API submits a failed test report",
                "body": "() => {\\n return sendReport(failedReport)\\n    }",
                "duration": 28,
                "status": "failed",
                "speed": "fast",
                "file": "/ReportFactory/report-factory-mocha/test/api_test.js",
                "timedOut": false,
                "pending": false,
                "sync":true,
                "async": 0,
                "currentRetry": 0,
                "err": "AssertionError: expected 'OK' to equal 'NO'"
              }
            ],
            "passes": 1,
            "pending": 0,
            "failures": 1,
            "start": "2019-01-21T23:42:40.010Z",
            "end": "2019-01-21T23:42:40.039Z",
            "duration": 29,
            "total": 1,
            "tags": ["test"]
          }
        }
      }
    end
  
    it 'is not authorized without X-API-KEY' do
      post '/api/v1/projects/web-app/reports/mocha', params: request_body
      expect(response.status).to eq(401)
    end

    it 'creates an mocha report' do
      post '/api/v1/projects/web-app/reports/mocha', headers: {
        'X-API-KEY' => tester.api_key
      }, params: request_body
      expect(response.status).to eq(201)
      expect(response.body).to be_json_response_for('mocha_report')
    end

    it 'does not allow an mocha report without tests', :fail do
      request_body_without_tests = request_body.tap do |body|
        body[:data][:attributes]['tests'] = nil
      end

      post '/api/v1/projects/web-app/reports/mocha', headers: {
        'X-API-KEY' => tester.api_key
      }, params: request_body_without_tests
      expect(response.status).to eq(400)
    end
  end

  describe 'GET show' do
    it 'is not authorized without X-API-KEY' do
      get "/api/v1/projects/Web-App/reports/mocha/#{mocha_report.id}"
      expect(response.status).to eq(401)
    end

    it 'shows an mocha report of a project' do
      get "/api/v1/projects/Web-App/reports/mocha/#{mocha_report.id}",
          headers: {
            'X-API-KEY' => tester.api_key
          }
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('mocha_report')
    end
  end
end
