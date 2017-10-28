# frozen_string_literal: true

# Provides logic and interface for Rspec Reports API
class RspecReportsController < ApplicationController
  before_action :set_project

  RSPEC_ATTRIBUTES = %i[version summary_line].freeze

  def index
    @reports = Report.includes(:reportable)
                     .where(project_id: @project.id,
                            reportable_type: 'RspecReport')
    @rspec_reports = @reports.collect(&:reportable)
    render jsonapi: @rspec_reports, status: :ok
  end

  def show
    @rspec_report = RspecReport.find(params.fetch(:id))
    render jsonapi: @rspec_report, status: :ok
  end

  def create
    @rspec_report = RspecReport.new(rspec_report_attributes)
    if @rspec_report.save && new_report.save
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

  def rspec_report_attributes
    rspec_report_params.fetch(:attributes, {})
  end

  def rspec_report_params
    params.require(:data).permit(attributes: RSPEC_ATTRIBUTES)
  end
end
