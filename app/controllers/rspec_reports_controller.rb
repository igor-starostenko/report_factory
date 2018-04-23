# frozen_string_literal: true

# Provides logic and interface for Rspec Reports API
class RspecReportsController < ApplicationController
  before_action :set_rspec_reports, only: %i[index]

  def index
    rspec_reports = ensure_in_bounds(@rspec_reports)
    render jsonapi: rspec_reports, status: :ok
  end

  def show
    @rspec_report = RspecReport.includes(examples: :exception)
                               .find(params.fetch(:id))
    render jsonapi: @rspec_report, status: :ok
  end

  private

  def set_rspec_reports
    rspec_reports = select_rspec_reports
    @rspec_reports = paginate(rspec_reports.order('rspec_reports.id desc'),
                              per_page: fetch_per_page)
  end

  def select_rspec_reports
    tags = fetch_tags
    rspec_reports = tags ? RspecReport.tags(tags) : RspecReport.with_summary
    @rspec_reports = rspec_reports.includes(:project, :report)
  end

  def fetch_per_page
    params.fetch(:per_page, 30)
  end

  def fetch_tags
    params[:tags]&.map(&:downcase)
  end
end
