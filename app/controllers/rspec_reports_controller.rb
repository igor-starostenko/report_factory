# frozen_string_literal: true

# Provides logic and interface for Rspec Reports API
class RspecReportsController < ApplicationController
  before_action :set_project

  RSPEC_REPORT_ATTRIBUTES = %i[version summary_line].freeze
  RSPEC_SUMMARY_ATTRIBUTES = {
    summary: %i[duration example_count failure_count
                errors_outside_of_examples_count
                pending_count]
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
    @rspec_report = RspecReport.new(attributes(:rspec_report))
    if @rspec_report.save && new_report.save && new_rspec_summary.save
      render jsonapi: @rspec_report, status: :created
    else
      render jsonapi_errors: @rspec_report.errors, status: :bad_request
    end
  end

  private

  def new_report
    @report = Report.new(project_id: @project.id,
                         reportable_type: RspecReport,
                         reportable_id: @rspec_report.id)
  end

  def new_rspec_summary
    args = { rspec_report_id: @rspec_report.id }
           .merge(attributes(:rspec_summary, [:summary]))
    @rspec_summary = RspecSummary.new(args)
  end
end
