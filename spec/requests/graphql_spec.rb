# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GraphQL', :graphql,
               type: :request do
  before do
    Rails.cache.clear
    FactoryBot.create(:tester,
                      name: 'user',
                      email: 'test@mailinator.com',
                      password: 'Qwerty12')

    project = FactoryBot.create(:project, project_name: 'Web App')

    rspec_report = FactoryBot.create(:rspec_report,
                                     version: '1.0.0',
                                     summary_line: '2 examples, 1 failures')

    mocha_report = FactoryBot.create(:mocha_report,
                                     suites: 2,
                                     total: 2,
                                     passes: 1,
                                     pending: 0,
                                     failures: 1,
                                     duration: 8,
                                     started: '2019-01-20T04:28:34.861Z',
                                     ended: '2019-01-20T04:28:34.867Z')

    first_report = FactoryBot.create(:report,
                                     project_id: project.id,
                                     tags: %w[High Full],
                                     reportable_type: RspecReport,
                                     reportable_id: rspec_report.id,
                                     status: 'failed')

    second_report = FactoryBot.create(:report,
                                      project_id: project.id,
                                      tags: %w[High Smoke],
                                      reportable_type: MochaReport,
                                      reportable_id: mocha_report.id,
                                      status: 'passed')

    FactoryBot.create(:user_report,
                      user_id: tester.id,
                      report_id: first_report.id)

    FactoryBot.create(:user_report,
                      user_id: tester.id,
                      report_id: second_report.id)
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

    FactoryBot.create(:mocha_test,
                      mocha_report_id: mocha_report.id,
                      title: 'submits a passed test',
                      full_title: 'ReportFactory API submits a passed test',
                      body: '() => {\n  return sendReport(report);\n}',
                      duration: 2,
                      status: 'passed',
                      speed: 'fast',
                      file: '/ReportFactory/report-factory/test/api_test.js',
                      timed_out: false,
                      pending: false,
                      sync: true,
                      async: 0,
                      current_retry: 0,
                      err: '')
  end
  let(:tester) { Tester.first }
  let(:project) { Project.first }
  let(:first_report) { Report.first }
  let(:second_report) { Report.last }
  let(:rspec_report) { RspecReport.last }
  let(:mocha_report) { MochaReport.last }
  let(:rspec_example) { RspecExample.last }
  let(:mocha_test) { RspecExample.last }
  let(:summary) { RspecSummary.last }
  let(:mocha_test) { MochaTest.last }

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
              type
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
        id: first_report.id,
        projectId: first_report.project_id.to_s,
        reportableId: first_report.reportable_id.to_s,
        reportableType: 'Rspec',
        status: first_report.status,
        tags: first_report.tags
      )
      expect(projects.first[:scenarios].second).to match_json_object(
        projectName: project.project_name,
        type: 'Rspec',
        specId: rspec_example.spec_id,
        description: rspec_example.description,
        fullDescription: rspec_example.full_description,
        status: rspec_example.status,
        lineNumber: rspec_example.line_number
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
              type
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
        id: first_report.id,
        projectId: first_report.project_id.to_s,
        reportableId: first_report.reportable_id.to_s,
        reportableType: 'Rspec',
        status: first_report.status,
        tags: first_report.tags
      )
      expect(actual_project[:scenarios].second).to match_json_object(
        projectName: project.project_name,
        type: 'Rspec',
        specId: rspec_example.spec_id,
        description: rspec_example.description,
        fullDescription: rspec_example.full_description,
        status: rspec_example.status,
        lineNumber: rspec_example.line_number
      )
      expect(actual_project[:scenarios].first).to match_json_object(
        projectName: project.project_name,
        type: 'Mocha',
        specId: mocha_test.spec_id,
        description: mocha_test.description,
        fullDescription: mocha_test.full_description,
        status: mocha_test.status,
        lineNumber: mocha_test.line_number
      )
    end
  end

  describe 'reportsConnection' do
    let(:query) do
      <<-GRAPHQL
        {
          reportsConnection(first: 10, tags: ["#{first_report.tags.first}"]) {
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
                  ...on MochaReport {
                    id
                    total
                    status
                    passes
                    failures
                    pending
                    suites
                    duration
                    started
                    ended
                  }
                  ...on RspecReport {
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
      report_two = connection.fetch(:edges).last.fetch(:node)
      expect(report_two).to match_json_object(
        id: first_report.id,
        projectName: project.project_name,
        status: rspec_example.status,
        reportableType: 'Rspec',
        createdAt: first_report.created_at.to_s,
        reportable: {
          summary: {
            duration: summary.duration,
            exampleCount: summary.example_count,
            pendingCount: summary.pending_count,
            failureCount: summary.failure_count
          }
        }
      )

      report_one = connection.fetch(:edges).first.fetch(:node)
      expect(report_one).to match_json_object(
        id: second_report.id,
        projectName: project.project_name,
        status: second_report.status,
        reportableType: 'Mocha',
        createdAt: second_report.created_at.to_s,
        reportable: {
          id: mocha_report.id,
          total: mocha_report.total,
          status: mocha_report.status,
          passes: mocha_report.passes,
          failures: mocha_report.failures,
          pending: mocha_report.pending,
          suites: mocha_report.suites,
          duration: mocha_report.duration,
          started: mocha_report.started.to_s,
          ended: mocha_report.ended.to_s
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
      report = connection.fetch(:edges).last.fetch(:node)
      expect(report).to match_json_object(
        id: rspec_report.id,
        version: rspec_report.version,
        summaryLine: rspec_report.summary_line,
        report: {
          projectName: project.project_name,
          reportableType: 'Rspec',
          createdAt: first_report.created_at.to_s
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

  describe 'mochaReportsConnection' do
    let(:query) do
      <<-GRAPHQL
        {
          mochaReportsConnection(projectName: "#{project.project_name}") {
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
                total
                status
                passes
                failures
                pending
                suites
                duration
                started
                ended
                report {
                  projectName
                  reportableType
                  createdAt
                }
                tests {
                  id
                  title
                  fullTitle
                  body
                  duration
                  status
                  speed
                  file
                  timedOut
                  pending
                  sync
                  async
                  currentRetry
                  err
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
      connection = parse_json_type(response.body, :mochaReportsConnection)
      expect(connection.fetch(:totalCount)).to eql(MochaReport.count)
      expect(connection.fetch(:pageInfo).keys.map(&:to_sym))
        .to match(%i[startCursor endCursor hasNextPage hasPreviousPage])
      report = connection.fetch(:edges).last.fetch(:node)
      expect(report).to match_json_object(
        id: mocha_report.id,
        total: mocha_report.total,
        status: mocha_report.status,
        passes: mocha_report.passes,
        failures: mocha_report.failures,
        pending: mocha_report.pending,
        suites: mocha_report.suites,
        duration: mocha_report.duration,
        started: mocha_report.started.to_s,
        ended: mocha_report.ended.to_s,
        report: {
          projectName: project.project_name,
          reportableType: 'Mocha',
          createdAt: second_report.created_at.to_s
        },
        tests: [{
          id: mocha_test.id,
          title: mocha_test.title,
          fullTitle: mocha_test.full_title,
          body: mocha_test.body,
          duration: mocha_test.duration,
          status: mocha_test.status,
          speed: mocha_test.speed,
          file: mocha_test.file,
          timedOut: mocha_test.timed_out,
          pending: mocha_test.pending,
          sync: mocha_test.sync,
          async: mocha_test.async,
          currentRetry: mocha_test.current_retry,
          err: mocha_test.err
        }]
      )
    end
  end

  describe 'scenarios' do
    let(:query) do
      <<-GRAPHQL
        {
          scenarios {
            projectName
            type
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
      expect(scenarios.second).to match_json_object(
        projectName: project.project_name,
        type: 'Rspec',
        specId: rspec_example.spec_id,
        description: rspec_example.description,
        fullDescription: rspec_example.full_description,
        status: rspec_example.status,
        lineNumber: rspec_example.line_number
      )
      expect(scenarios.first).to match_json_object(
        projectName: project.project_name,
        type: 'Mocha',
        specId: mocha_test.spec_id,
        description: mocha_test.description,
        fullDescription: mocha_test.full_description,
        status: mocha_test.status,
        lineNumber: mocha_test.line_number
      )
    end
  end

  describe 'scenario' do
    context RspecExample do
      let(:query) do
        <<-GRAPHQL
          {
            scenario(projectName: "#{project.project_name}",
                     scenarioName: "#{rspec_example.full_description}") {
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
          name: rspec_example.full_description,
          lastStatus: rspec_example.status,
          lastRun: rspec_example.report.created_at.to_s,
          lastPassed: nil,
          lastFailed: first_report.created_at.to_s,
          totalRuns: 1,
          totalPassed: 0,
          totalFailed: 1,
          totalPending: 0
        )
      end
    end

    context MochaTest do
      let(:query) do
        <<-GRAPHQL
          {
            scenario(projectName: "#{project.project_name}",
                     scenarioName: "#{mocha_test.full_title}") {
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
          name: mocha_test.full_title,
          projectName: project.project_name,
          lastStatus: mocha_test.status,
          lastRun: mocha_test.report.created_at.to_s,
          lastPassed: second_report.created_at.to_s,
          lastFailed: nil,
          totalRuns: 1,
          totalPassed: 1,
          totalFailed: 0,
          totalPending: 0
        )
      end
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
          createdAt: first_report.created_at.to_s
        }, {
          projectName: project.project_name,
          createdAt: second_report.created_at.to_s
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
          createdAt: first_report.created_at.to_s
        }, {
          projectName: project.project_name,
          createdAt: second_report.created_at.to_s
        }]
      )
    end
  end
end
