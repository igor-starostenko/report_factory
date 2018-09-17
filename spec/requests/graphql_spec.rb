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
    report = FactoryBot.create(:report,
                               project_id: project.id,
                               tags: %w[High Full],
                               reportable_type: RspecReport,
                               reportable_id: rspec_report.id,
                               status: 'failed')
    FactoryBot.create(:user_report,
                      user_id: tester.id,
                      report_id: report.id)
    FactoryBot.create(:rspec_summary,
                      rspec_report_id: rspec_report.id,
                      duration: 0.054,
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
  let(:rspec_report) { RspecReport.last }
  let(:scenario) { RspecExample.last }
  let(:summary) { RspecSummary.last }

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
            projectName
            createdAt
            updatedAt
            reports {
              id
              projectId
              reportableId
              reportableType
              status
              tags
            }
            scenarios {
              projectName
              specId
              status
              description
              fullDescription
              lineNumber
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
      projects = parse_json_type(response.body, :projects)
      expect(projects.size).to be_positive
      expect(projects.first).to match_json_object(
        id: project.id,
        projectName: project.project_name,
        createdAt: project.created_at.to_s,
        updatedAt: project.updated_at.to_s
      )
      expect(projects.first[:reports].first).to match_json_object(
        id: report.id,
        projectId: report.project_id.to_s,
        reportableId: report.reportable_id.to_s,
        reportableType: 'Rspec',
        status: report.status,
        tags: report.tags
      )
      expect(projects.first[:scenarios].first).to match_json_object(
        projectName: project.project_name,
        specId: scenario.spec_id,
        description: scenario.description,
        fullDescription: scenario.full_description,
        status: scenario.status,
        lineNumber: scenario.line_number
      )
    end
  end

  describe 'project' do
    let(:query) do
      <<-GRAPHQL
        {
          project(projectName: "#{project.project_name}") {
            id
            projectName
            createdAt
            updatedAt
            reportsCount
            reports {
              id
              projectId
              reportableId
              reportableType
              status
              tags
              createdAt
              updatedAt
            }
            scenarios {
              projectName
              specId
              status
              description
              fullDescription
              lineNumber
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
      actual_project = parse_json_type(response.body, :project)
      expect(actual_project).to match_json_object(
        id: project.id,
        projectName: project.project_name,
        createdAt: project.created_at.to_s,
        updatedAt: project.updated_at.to_s,
        reportsCount: project.reports.count
      )
      expect(actual_project[:reports].first).to match_json_object(
        id: report.id,
        projectId: report.project_id.to_s,
        reportableId: report.reportable_id.to_s,
        reportableType: 'Rspec',
        status: report.status,
        tags: report.tags
      )
      expect(actual_project[:scenarios].first).to match_json_object(
        projectName: project.project_name,
        specId: scenario.spec_id,
        description: scenario.description,
        fullDescription: scenario.full_description,
        status: scenario.status,
        lineNumber: scenario.line_number
      )
    end
  end

  describe 'reportsConnection' do
    let(:query) do
      <<-GRAPHQL
        {
          reportsConnection(first: 10, tags: ["#{report.tags.first}"]) {
            totalCount
            pageInfo {
              startCursor
              endCursor
              hasNextPage
              hasPreviousPage
            }
            edges {
              cursor
              node {
                id
                projectName
                status
                reportableType
                createdAt
                reportable {
                  summary {
                    duration
                    exampleCount
                    pendingCount
                    failureCount
                  }
                }
              }
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
      connection = parse_json_type(response.body, :reportsConnection)
      expect(connection.fetch(:totalCount)).to eql(Report.all.count)
      expect(connection.fetch(:pageInfo).keys.map(&:to_sym))
        .to match(%i[startCursor endCursor hasNextPage hasPreviousPage])
      first_report = connection.fetch(:edges).first.fetch(:node)
      expect(first_report).to match_json_object(
        id: report.id,
        projectName: project.project_name,
        status: scenario.status,
        reportableType: 'Rspec',
        createdAt: report.created_at.to_s,
        reportable: {
          summary: {
            duration: summary.duration,
            exampleCount: summary.example_count,
            pendingCount: summary.pending_count,
            failureCount: summary.failure_count
          }
        }
      )
    end
  end

  describe 'rspecReportsConnection' do
    let(:query) do
      <<-GRAPHQL
        {
          rspecReportsConnection(projectName: "#{project.project_name}") {
            totalCount
            pageInfo {
              startCursor
              endCursor
              hasNextPage
              hasPreviousPage
            }
            edges {
              cursor
              node {
                id
                version
                summaryLine
                report {
                  projectName
                  reportableType
                  createdAt
                }
                summary {
                  duration
                  exampleCount
                  pendingCount
                  failureCount
                }
              }
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
      connection = parse_json_type(response.body, :rspecReportsConnection)
      expect(connection.fetch(:totalCount)).to eql(RspecReport.count)
      expect(connection.fetch(:pageInfo).keys.map(&:to_sym))
        .to match(%i[startCursor endCursor hasNextPage hasPreviousPage])
      first_report = connection.fetch(:edges).first.fetch(:node)
      expect(first_report).to match_json_object(
        id: rspec_report.id,
        version: rspec_report.version,
        summaryLine: rspec_report.summary_line,
        report: {
          projectName: project.project_name,
          reportableType: 'Rspec',
          createdAt: report.created_at.to_s
        },
        summary: {
          duration: summary.duration,
          exampleCount: summary.example_count,
          pendingCount: summary.pending_count,
          failureCount: summary.failure_count
        }
      )
    end
  end

  describe 'scenarios' do
    let(:query) do
      <<-GRAPHQL
        {
          scenarios {
            projectName
            specId
            description
            fullDescription
            status
            lineNumber
          }
        }
      GRAPHQL
    end

    it 'gets all available attributes' do
      post '/graphql', headers: {
        'X-API-KEY' => tester.api_key
      }, params: { query: query }
      expect(response.status).to eq(200)
      scenarios = parse_json_type(response.body, :scenarios)
      expect(scenarios.size).to be_positive
      expect(scenarios.first).to match_json_object(
        projectName: project.project_name,
        specId: scenario.spec_id,
        description: scenario.description,
        fullDescription: scenario.full_description,
        status: scenario.status,
        lineNumber: scenario.line_number
      )
    end
  end

  describe 'scenario' do
    let(:query) do
      <<-GRAPHQL
        {
          scenario(projectName: "#{project.project_name}",
                   scenarioName: "#{scenario.full_description}") {
            name
            projectName
            lastStatus
            lastRun
            lastPassed
            lastFailed
            totalRuns
            totalPassed
            totalFailed
            totalPending
          }
        }
      GRAPHQL
    end

    it 'gets all available attributes' do
      post '/graphql', headers: {
        'X-API-KEY' => tester.api_key
      }, params: { query: query }
      expect(response.status).to eq(200)
      actual_scenario = parse_json_type(response.body, :scenario)
      expect(actual_scenario).to match_json_object(
        name: scenario.full_description,
        lastStatus: scenario.status,
        lastRun: scenario.report.created_at.to_s,
        lastPassed: nil,
        lastFailed: report.created_at.to_s,
        totalRuns: 1,
        totalPassed: 0,
        totalFailed: 1,
        totalPending: 0
      )
    end
  end

  describe 'users' do
    let(:query) do
      <<-GRAPHQL
        {
          users {
            id
            email
            name
            reports {
              projectName
              createdAt
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
      users = parse_json_type(response.body, :users)
      expect(users.size).to be_positive
      expect(users.first).to match_json_object(
        id: tester.id,
        email: tester.email,
        name: tester.name,
        reports: [{
          projectName: project.project_name,
          createdAt: report.created_at.to_s
        }]
      )
    end
  end

  describe 'user' do
    let(:query) do
      <<-GRAPHQL
        {
          user(id: #{tester.id}) {
            id
            email
            name
            reportsCount
            reports {
              projectName
              createdAt
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
      user = parse_json_type(response.body, :user)
      expect(user).to match_json_object(
        id: tester.id,
        email: tester.email,
        name: tester.name,
        reportsCount: tester.reports.count,
        reports: [{
          projectName: project.project_name,
          createdAt: report.created_at.to_s
        }]
      )
    end
  end
end
