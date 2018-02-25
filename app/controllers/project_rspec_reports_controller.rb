# frozen_string_literal: true

# Provides logic and interface for Project Rspec Reports API
class ProjectRspecReportsController < BaseProjectsController
  before_action :set_project

  REPORT_ATTRIBUTES = %i[version summary_line].freeze
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
    @reports = paginate(Report.includes(:reportable)
                         .where(project_id: @project.id,
                                reportable_type: 'RspecReport'),
                            per_page: per_page)
    @rspec_reports = @reports.collect(&:reportable)
    render jsonapi: @rspec_reports, status: :ok
  end

  def show
    @rspec_report = RspecReport.includes(:report, :project)
                               .find(params.fetch(:id))
    render jsonapi: @rspec_report, status: :ok
  end

  def create
    @rspec_report = RspecReport.new(attributes(:report))
    if save_rspec_report
      render jsonapi: @rspec_report, status: :created
    else
      render jsonapi_errors: @rspec_report.errors, status: :bad_request
    end
  end

  private

  def save_rspec_report
    @rspec_report.save && new_report.save && new_rspec_summary.save &&
      save_all_examples && new_user_report.save
  end

  def new_report
    @report = Report.new(project_id: @project.id,
                         reportable_type: RspecReport,
                         reportable_id: @rspec_report.id)
  end

  def new_user_report
    @user_report = UserReport.new(user_id: @auth_user.id,
                                  report_id: @report.id)
  end

  def new_rspec_summary
    args = { rspec_report_id: @rspec_report.id }
           .merge(attributes(:summary, :summary))
    @rspec_summary = RspecSummary.new(args)
  end

  def save_all_examples
    attributes(:example, :examples).each do |example_args|
      args = { rspec_report_id: @rspec_report.id, spec_id: example_args[:id] }
      formatted_args = args.merge(example_args).except('id', 'exception')
      @rspec_example = RspecExample.new(formatted_args)
      @rspec_example.save
      save_exception(example_args['exception']) if example_args['exception']
    end
  end

  def save_exception(exception)
    args = { rspec_example_id: @rspec_example.id,
             classname: exception['class'] }
    RspecException.new(args.merge(exception).except('class')).save
  end
end
