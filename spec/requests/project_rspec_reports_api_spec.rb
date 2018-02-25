# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ProjectRspecReports', :project_rspec_reports_api,
               type: :request do
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
                      reportable_id: rspec_report.id)
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
      get '/api/v1/projects/web-app/reports/rspec'
      expect(response.status).to eq(401)
    end

    it 'gets all rspec reports within project' do
      get '/api/v1/projects/web-app/reports/rspec', headers: {
        'X-API-KEY' => tester.api_key
      }
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('rspec_report')
    end
  end

  describe 'POST create' do
    it 'is not authorized without X-API-KEY' do
      post '/api/v1/projects/web-app/reports/rspec', params: {
        data: {
          type: 'rspec_report',
          attributes: {
            "version": '3.7.0',
            "examples": [
              {
                "id": './spec/models/project_spec.rb[1:1]',
                "description": 'is valid',
                "full_description": 'Project is valid',
                "status": 'passed',
                "file_path": './spec/models/project_spec.rb',
                "line_number": 8,
                "run_time": 0.012945,
                "pending_message": nil
              }
            ],
            "summary": {
              "duration": 0.147558,
              "example_count": 1,
              "failure_count": 0,
              "pending_count": 0,
              "errors_outside_of_examples_count": 0
            },
            "summary_line": '1 examples, 0 failures'
          }
        }
      }
      expect(response.status).to eq(401)
    end

    it 'creates an rspec report' do
      post '/api/v1/projects/web-app/reports/rspec', headers: {
        'X-API-KEY' => tester.api_key
      }, params: {
        data: {
          type: 'rspec_report',
          attributes: {
            "version": '3.7.0',
            "examples": [
              {
                "id": './spec/models/project_spec.rb[1:1]',
                "description": 'is valid',
                "full_description": 'Project is valid',
                "status": 'passed',
                "file_path": './spec/models/project_spec.rb',
                "line_number": 8,
                "run_time": 0.012945,
                "pending_message": nil
              },
              {
                "id": './spec/requests/rspec_reports_api_spec.rb[1:1:1]',
                "description": 'gets all rspec reports within project',
                "full_description": 'RspecReports GET index gets all '\
                'rspec reports within project',
                "status": 'failed',
                "file_path": './spec/requests/rspec_reports_api_spec.rb',
                "line_number": 11,
                "run_time": 0.032876,
                "pending_message": nil,
                "exception": {
                  "class": 'RSpec::Expectations::ExpectationNotMetError',
                  "message": "\nexpected: 200\n    "\
                  "got: 204\n\n(compared using ==)\n",
                  "backtrace": [
                    "./support.rb:97:in `block in \u003cmodule:Support\u003e'",
                    "./support.rb:106:in `notify_failure'",
                    "./expectations/fail_with.rb:35:in `fail_with'",
                    "./expectations/handler.rb:38:in `handle_failure'",
                    "./expectations/handler.rb:50:in `block in handle_matcher'",
                    "./expectations/handler.rb:27:in `with_matcher'",
                    "./expectations/handler.rb:48:in `handle_matcher'",
                    "./expectations/expectation_target.rb:65:in `to'"
                  ]
                }
              },
              {
                "id": './spec/models/project_spec.rb[1:2]',
                "description": 'has :timestamps',
                "full_description": 'Project has :timestamps',
                "status": 'passed',
                "file_path": './spec/models/project_spec.rb',
                "line_number": 12,
                "run_time": 0.004452,
                "pending_message": nil
              }
            ],
            "summary": {
              "duration": 0.747558,
              "example_count": 3,
              "failure_count": 1,
              "pending_count": 0,
              "errors_outside_of_examples_count": 0
            },
            "summary_line": '3 examples, 1 failures'
          }
        }
      }
      expect(response.status).to eq(201)
      expect(response.body).to be_json_response_for('rspec_report')
    end
  end

  describe 'GET show' do
    it 'is not authorized without X-API-KEY' do
      get "/api/v1/projects/Web-App/reports/rspec/#{rspec_report.id}"
      expect(response.status).to eq(401)
    end

    it 'shows an rspec report of a project' do
      get "/api/v1/projects/Web-App/reports/rspec/#{rspec_report.id}",
          headers: {
            'X-API-KEY' => tester.api_key
          }
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('rspec_report')
    end
  end
end
