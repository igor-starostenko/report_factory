# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GraphQL', :graphql,
               type: :request do
  before do
    FactoryBot.create(:tester,
                      name: 'user',
                      email: 'test@mailinator.com',
                      password: 'Qwerty12')
    project = FactoryBot.create(:project, project_name: 'Web App')
    rspec_report = FactoryBot.create(:rspec_report,
                                     version: '1.0.0',
                                     summary_line: '2 examples, 1 failures')
    FactoryBot.create(:report,
                      project_id: project.id,
                      tags: %w[High Full],
                      reportable_type: RspecReport,
                      reportable_id: rspec_report.id,
                      status: 'failed')
    FactoryBot.create(:rspec_summary,
                      rspec_report_id: rspec_report.id,
                      example_count: 2,
                      failure_count: 1,
                      pending_count: 0)
    FactoryBot.create(:rspec_example,
                      rspec_report_id: rspec_report.id,
                      spec_id: './spec/requests/user_reports_spec.rb[1:1:4]',
                      description: 'GET index all reports',
                      full_description: 'UserReports GET index all reports',
                      status: 'passed',
                      file_path: './spec/requests/user_reports_api_spec.rb',
                      line_number: 20,
                      run_time: 0.026194,
                      pending_message: 'message')
    FactoryBot.create(:rspec_example,
                      rspec_report_id: rspec_report.id,
                      spec_id: './spec/requests/user_reports_api_spec.rb[1:4]',
                      description: 'belongs to one :rspec_report',
                      full_description: 'RspecSummary belongs to one',
                      status: 'failed',
                      file_path: './spec/requests/user_reports_api_spec.rb',
                      line_number: 49,
                      run_time: 0.036294,
                      pending_message: '2message')
  end
  let(:tester) { Tester.first }
  let(:project) { Project.first }
  let(:report) { Report.last }
  let(:scenario) { RspecExample.last }

  it 'is not authorized without X-API-KEY' do
    post '/graphql'
    expect(response.status).to eq(401)
  end

  describe 'projects' do
    let(:query) do
      <<-GRAPHQL
        {
          projects {
            id
            project_name
            created_at
            updated_at
            reports {
              id
              project_id
              reportable_id
              reportable_type
              status
              tags
            }
            scenarios {
              project_name
              spec_id
              status
              description
              full_description
              line_number
            }
          }
        }
      GRAPHQL
    end

    it 'gets all available attributes' do
      post '/graphql', headers: {
        'X-API-KEY' => tester.api_key
      }, params: { query: query }
      expect(response.status).to eq(200)
      projects = parse_json_type(response.body, 'projects')
      expect(projects.size).to be_positive
      expect(projects.first).to match_json_object({
        id: project.id.to_s,
        project_name: project.project_name,
        created_at: project.created_at.to_s,
        updated_at: project.updated_at.to_s,
      })
      expect(projects.first['reports'].first).to match_json_object({
        id: report.id.to_s,
        project_id: report.project_id.to_s,
        reportable_id: report.reportable_id.to_s,
        reportable_type: report.reportable_type,
        status: report.status,
        tags: report.tags
      })
      expect(projects.first['scenarios'].first).to match_json_object({
        project_name: project.project_name,
        spec_id: scenario.spec_id,
        description: scenario.description,
        full_description: scenario.full_description,
        status: scenario.status,
        line_number: scenario.line_number
      })
    end
  end

  describe 'project' do
    let(:query) do
      <<-GRAPHQL
        {
          project(project_name: "#{project.project_name}") {
            id
            project_name
            created_at
            updated_at
            reports {
              id
              project_id
              reportable_id
              reportable_type
              status
              tags
              created_at
              updated_at
            }
            scenarios {
              project_name
              spec_id
              status
              description
              full_description
              line_number
            }
          }
        }
      GRAPHQL
    end

    it 'gets all available attributes' do
      post '/graphql', headers: {
        'X-API-KEY' => tester.api_key
      }, params: { query: query }
      expect(response.status).to eq(200)
      actual_project = parse_json_type(response.body, 'project')
      expect(actual_project).to match_json_object({
        id: project.id.to_s,
        project_name: project.project_name,
        created_at: project.created_at.to_s,
        updated_at: project.updated_at.to_s,
      })
      expect(actual_project['reports'].first).to match_json_object({
        id: report.id.to_s,
        project_id: report.project_id.to_s,
        reportable_id: report.reportable_id.to_s,
        reportable_type: report.reportable_type,
        status: report.status,
        tags: report.tags
      })
      expect(actual_project['scenarios'].first).to match_json_object({
        project_name: project.project_name,
        spec_id: scenario.spec_id,
        description: scenario.description,
        full_description: scenario.full_description,
        status: scenario.status,
        line_number: scenario.line_number
      })
    end
  end

  describe 'scenarios' do
    let(:query) do
      <<-GRAPHQL
        {
          scenarios {
            project_name
            spec_id
            description
            full_description
            status
            line_number
          }
        }
      GRAPHQL
    end

    it 'gets all available attributes' do
      post '/graphql', headers: {
        'X-API-KEY' => tester.api_key
      }, params: { query: query }
      expect(response.status).to eq(200)
      scenarios = parse_json_type(response.body, 'scenarios')
      expect(scenarios.size).to be_positive
      expect(scenarios.first).to match_json_object({
        project_name: project.project_name,
        spec_id: scenario.spec_id,
        description: scenario.description,
        full_description: scenario.full_description,
        status: scenario.status,
        line_number: scenario.line_number
      })
    end
  end

  describe 'scenario' do
    let(:query) do
      <<-GRAPHQL
        {
          scenario(project_name: "#{project.project_name}",
                   scenario_name: "#{scenario.full_description}") {
            name
            last_status
            last_run
            last_passed
            last_failed
            total_runs
            total_passed
            total_failed
            total_pending
          }
        }
      GRAPHQL
    end

    it 'gets all available attributes' do
      post '/graphql', headers: {
        'X-API-KEY' => tester.api_key
      }, params: { query: query }
      expect(response.status).to eq(200)
      actual_scenario = parse_json_type(response.body, 'scenario')
      expect(actual_scenario).to match_json_object({
        name: scenario.full_description,
        last_status: scenario.status,
        last_run: scenario.report.created_at.to_s,
        last_passed: nil,
        last_failed: report.created_at.to_s,
        total_runs: 1,
        total_passed: 0,
        total_failed: 1,
        total_pending: 0
      })
    end
  end
end
