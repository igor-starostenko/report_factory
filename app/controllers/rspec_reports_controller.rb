# frozen_string_literal: true

# Provides logic and interface for Rspec Reports API
class RspecReportsController < ApplicationController
  def index
    per_page = params.fetch(:per_page, 30)
    search_tags(per_page: per_page,
                tags: params[:tags]&.map(&:downcase))
    @rspec_reports = ensure_in_bounds(@rspec_reports)
    render jsonapi: @rspec_reports, status: :ok
  end

  def show
    @rspec_report = RspecReport.find(params.fetch(:id))
    render jsonapi: @rspec_report, status: :ok
  end

  private

  def search_tags(per_page:, tags: nil)
    rspec_reports = tags ? RspecReport.tags(tags) : RspecReport.with_summary
    @rspec_reports = paginate(rspec_reports.order('id desc'),
                              per_page: per_page)
  end
end
