# frozen_string_literal: true

# Provides logic and interface for Reports API
class ReportsController < ApplicationController
  def index
    per_page = params.fetch(:per_page, 30)
    search_tags(per_page: per_page,
                tags: params[:tags]&.map(&:downcase))
    @reports = ensure_in_bounds(@reports)
    render jsonapi: @reports, status: :ok
  end

  def show
    @report = Report.find(params.fetch(:id))
    render jsonapi: @report, status: :ok
  end

  private

  def search_tags(per_page:, tags: nil)
    reports = tags ? Report.tags(tags) : Report.all
    @reports = paginate(reports.order('id desc'),
                        per_page: per_page)
  end
end
