# frozen_string_literal: true

# Provides logic and interface for Project Rspec Reports API
class ProjectRspecReportsController < BaseProjectsController
  before_action :set_project

  REPORT_ATTRIBUTES = { tags: [] }.freeze
  RSPEC_REPORT_ATTRIBUTES = %i[version summary_line].freeze
  SUMMARY_ATTRIBUTES = {
    summary: %i[duration example_count failure_count
                errors_outside_of_examples_count
                pending_count]
  }.freeze
  EXAMPLE_ATTRIBUTES = {
    examples: [:id, :description, :full_description, :status, :file_path,
               :line_number, :run_time, :pending_message,
               { exception: [:class, :message, { backtrace: [] }] }]
  }.freeze

  def index
    per_page = params.fetch(:per_page, 30)
    search_tags(per_page: per_page, tags: params[:tags]&.map(&:downcase))
    @rspec_reports = ensure_in_bounds(@rspec_reports)
    render jsonapi: @rspec_reports, status: :ok
  end

  def show
    @rspec_report = RspecReport.includes(:report, :project)
                               .find(params.fetch(:id))
    render jsonapi: @rspec_report, status: :ok
  end

  def create
    return render_bad_report unless valid_report?
    if new_rspec_report.save
      new_report.save && new_user_report.save
      render jsonapi: @rspec_report, status: :created
    else
      render jsonapi_errors: @rspec_report.errors, status: :bad_request
    end
  end

  private

  def search_tags(per_page:, tags: nil)
    reports = tags ? reports_by_tags(tags) : all_reports
    reports_desc = reports.order('rspec_reports.id desc')
    @rspec_reports = paginate(reports_desc, per_page: per_page)
  end

  def reports_by_tags(tags)
    RspecReport.tags_by_project(@project.project_name, tags)
  end

  def all_reports
    RspecReport.by_project(@project.project_name).includes(:report)
  end

  def valid_report?
    examples = attributes(:example, :examples)
    attributes(:summary, :summary) &&
      examples && examples.size.positive?
  end

  def new_rspec_report
    @rspec_report = RspecReport.new(attributes(:rspec_report)
      .merge(summary_attributes: attributes(:summary, :summary),
             examples_attributes: rspec_examples_attributes))
  end

  def new_report
    @report = Report.new(project_id: @project.id,
                         reportable_type: RspecReport,
                         tags: attributes(:report).fetch(:tags, []),
                         reportable_id: @rspec_report.id)
  end

  def new_user_report
    @user_report = UserReport.new(user_id: @auth_user.id,
                                  report_id: @report.id)
  end

  def rspec_examples_attributes
    attributes(:example, :examples).map do |example_args|
      exception_attributes = rspec_exception_attributes(example_args[:exception])
      args = { spec_id: example_args[:id],
               exception_attributes: exception_attributes }
      args.merge(example_args).except('id', 'exception')
    end
  end

  def rspec_exception_attributes(exception_args)
      return {} unless exception_args
      { 'classname' => exception_args[:class] }.merge(exception_args).except('class')
  end

  def render_bad_report
    render json: { error: 'Bad report' }, status: :bad_request
  end
end
