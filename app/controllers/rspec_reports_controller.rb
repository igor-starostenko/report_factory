# frozen_string_literal: true

# Provides logic and interface for Rspec Reports API
class RspecReportsController < ApplicationController
  before_action :set_rspec_reports, only: %i[index]

  def index
    render jsonapi: ensure_in_bounds(@rspec_reports), status: :ok
  end

  def show
    @rspec_report = RspecReport.with_exceptions.find(params.fetch(:id))
    render jsonapi: @rspec_report, status: :ok
  end

  private

  def set_rspec_reports
    @rspec_reports = paginate(select_rspec_reports, per_page: per_page)
  end

  def select_rspec_reports
    rspec_reports = RspecReport.all_details
    tags ? rspec_reports.tags(tags) : rspec_reports
  end

  def per_page
    @per_page ||= params.fetch(:per_page, 30)
  end

  def tags
    @tags ||= params[:tags]&.map(&:downcase)
  end
end
