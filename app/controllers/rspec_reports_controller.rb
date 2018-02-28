# frozen_string_literal: true

# Provides logic and interface for Rspec Reports API
class RspecReportsController < ApplicationController
  def index
    per_page = params.fetch(:per_page, 30)
    reports = RspecReport.all.order('id desc')
    rspec_reports = paginate(reports, per_page: per_page)
    @rspec_reports = ensure_in_bounds(rspec_reports)
    render jsonapi: @rspec_reports, status: :ok
  end

  def show
    @rspec_report = RspecReport.find(params.fetch(:id))
    render jsonapi: @rspec_report, status: :ok
  end
end
