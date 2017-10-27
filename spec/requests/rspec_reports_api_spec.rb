# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RspecReports', :rspec_reports_api, type: :request do
  before do
    project = FactoryBot.create(:project, project_name: 'Web App')
    rspec_report = FactoryBot.create(:rspec_report,
                                     version: '1.0.0',
                                     summary_line: '8 examples, 0 failures')
    FactoryBot.create(:report,
                      project_id: project.id,
                      reportable_type: RspecReport,
                      reportable_id: rspec_report.id)
  end

  describe 'GET index' do
    it 'gets all rspec reports within project' do
      get '/api/v1/projects/web_app/reports/rspec'
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('rspec_report')
    end
  end

  describe 'POST create' do
    it 'creates an rspec report' do
      post '/api/v1/projects/web_app/reports/rspec', params: {
        data: {
          type: 'rspec_report',
          attributes: {
            "version": "3.7.0",
            "examples": [
              {
                "id": "./spec/models/project_spec.rb[1:1]",
                "description": "is valid",
                "full_description": "Project is valid",
                "status": "passed",
                "file_path": "./spec/models/project_spec.rb",
                "line_number": 8,
                "run_time": 0.012945,
                "pending_message": null
              },
              {
                "id": "./spec/models/project_spec.rb[1:2]",
                "description": "has :timestamps",
                "full_description": "Project has :timestamps",
                "status": "passed",
                "file_path": "./spec/models/project_spec.rb",
                "line_number": 12,
                "run_time": 0.004452,
                "pending_message": null
              }
            ],
            "summary": {
              "duration": 0.747558,
              "example_count": 2,
              "failure_count": 0,
              "pending_count": 0,
              "errors_outside_of_examples_count": 0
            },
            "summary_line": "2 examples, 0 failures"
          }
        }
      }
      expect(response.status).to eq(201)
      expect(response.body).to be_json_response_for('rspec_report')
    end
  end

  describe 'GET show' do
    it 'shows a project' do
      get '/api/v1/projects/Web_App/reports/rspec/1'
      expect(response.status).to eq(200)
      expect(response.body).to be_json_response_for('rspec_report')
    end
  end
end
