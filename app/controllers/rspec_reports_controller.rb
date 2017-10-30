# frozen_string_literal: true

# Provides logic and interface for Rspec Reports API
class RspecReportsController < ApplicationController
  before_action :set_project

  REPORT_ATTRIBUTES = %i[version summary_line].freeze
  SUMMARY_ATTRIBUTES = {
    summary: %i[duration example_count failure_count
                errors_outside_of_examples_count
                pending_count]
  }.freeze
  EXAMPLE_ATTRIBUTES = {
    examples: %i[id description full_description status file_path
                 line_number run_time pending_message].freeze
  }.freeze

  def index
    @reports = Report.includes(:reportable)
                     .where(project_id: @project.id,
                            reportable_type: 'RspecReport')
    @rspec_reports = @reports.collect(&:reportable)
    render jsonapi: @rspec_reports, status: :ok
  end

  def show
    @rspec_report = RspecReport.includes(:report, :project)
                               .where(id: params.fetch(:id))
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
    @rspec_report.save && new_report.save &&
      new_rspec_summary.save && save_all_examples
  end

  def new_report
    @report = Report.new(project_id: @project.id,
                         reportable_type: RspecReport,
                         reportable_id: @rspec_report.id)
  end

  def new_rspec_summary
    args = { rspec_report_id: @rspec_report.id }
           .merge(attributes(:summary, [:summary]))
    @rspec_summary = RspecSummary.new(args)
  end

  def save_all_examples
    attributes(:example, [:examples]).each do |example_args|
      args = { rspec_report_id: @rspec_report.id, spec_id: example_args[:id] }
      RspecExample.new(args.merge(example_args).except('id')).save
    end
  end
end
