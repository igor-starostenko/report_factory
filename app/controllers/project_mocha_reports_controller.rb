# frozen_string_literal: true

# Provides logic and interface for Project Mocha Reports API
class ProjectMochaReportsController < BaseProjectsController
  include ProjectReportsHelper

  before_action :set_project
  before_action :search_tags, only: %i[index]

  REPORT_ATTRIBUTES = { tags: [] }.freeze
  MOCHA_REPORT_ATTRIBUTES = %i[suites total passes pending failures start end
                               duration].freeze
  TEST_ATTRIBUTES = {
    tests: [:title, :fullTitle, :body, :duration, :status, :speed, :file,
            :timedOut, :pending, :sync, :async, :currentRetry, :err]
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
      new_report.save && new_user_report.save
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
    tests && tests.size.positive?
  end

  def new_mocha_report
    @mocha_report = MochaReport.new(attributes(:mocha_report)
      .merge(tests_attributes: mocha_tests_attributes))
  end

  def new_report
    @report = Report.new(project_id: @project.id,
                         reportable_type: MochaReport,
                         status: @mocha_report.status,
                         tags: attributes(:report).fetch(:tags, []),
                         reportable_id: @mocha_report.id)
  end

  def new_user_report
    @user_report = UserReport.new(user_id: @auth_user.id,
                                  report_id: @report.id)
  end

  def mocha_tests_attributes
    attributes(:test, :tests).map do |test_args|
      { 'full_title' => test_args[:fullTitle],
        'timed_out' => test_args[:timedOut],
        'current_retry' => test_args[:currentRetry] }
        .merge(test_args).except('fullTile', 'timedOut', 'currentRetry')
    end
  end

  def render_bad_report
    render json: { error: 'Bad report' }, status: :bad_request
  end

  def per_page
    @per_page ||= params.fetch(:per_page, 30)
  end

  def tags
    @tags ||= params[:tags]&.map(&:downcase)
  end
end

