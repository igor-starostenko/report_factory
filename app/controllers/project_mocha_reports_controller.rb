# frozen_string_literal: true

# Provides logic and interface for Project Mocha Reports API
class ProjectMochaReportsController < BaseProjectsController
  include ProjectReportsHelpers

  before_action :set_project
  before_action :search_tags, only: %i[index]

  REPORT_ATTRIBUTES = { tags: [] }.freeze
  MOCHA_REPORT_ATTRIBUTES = %i[suites total passes pending failures started
                               ended duration].freeze
  TEST_ATTRIBUTES = {
    tests: %i[title fullTitle body duration status speed file
              timedOut pending sync async currentRetry err]
  }.freeze

  def index
    render jsonapi: ensure_in_bounds(@mocha_reports), status: :ok
  end

  def show
    @mocha_report = MochaReport.includes(:report, :project)
                               .find(params.fetch(:id))
    render jsonapi: @mocha_report, status: :ok
  end

  def create
    return render_bad_report unless valid_report?
    if new_mocha_report.save
      new_report(@mocha_report).save && new_user_report.save
      render jsonapi: @mocha_report, status: :created
    else
      render jsonapi_errors: @mocha_report.errors, status: :bad_request
    end
  end

  private

  def search_tags
    reports = tags ? reports_by_tags(tags) : all_reports
    reports_desc = reports.order('mocha_reports.id desc')
    @mocha_reports = paginate(reports_desc, per_page: per_page)
  end

  def reports_by_tags(tags)
    MochaReport.all_details.tags_by_project(@project.project_name, tags)
  end

  def all_reports
    MochaReport.all_details.by_project(@project.project_name).includes(:report)
  end

  def valid_report?
    tests = attributes(:test, :tests)
    tests&.size&.positive?
  end

  def new_mocha_report
    @mocha_report = MochaReport.new(attributes(:mocha_report)
      .merge(tests_attributes: mocha_tests_attributes))
  end

  def mocha_tests_attributes
    attributes(:test, :tests).map do |test_args|
      { 'full_title' => test_args[:fullTitle],
        'timed_out' => test_args[:timedOut],
        'current_retry' => test_args[:currentRetry] }
        .merge(test_args).except('fullTitle', 'timedOut', 'currentRetry')
    end
  end
end
