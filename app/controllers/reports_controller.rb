# frozen_string_literal: true

# Provides logic and interface for Reports API
class ReportsController < ApplicationController
  before_action :search_tags, only: %i[index]

  def index
    render jsonapi: ensure_in_bounds(@reports), status: :ok
  end

  def show
    @report = Report.find(params.fetch(:id))
    render jsonapi: @report, status: :ok
  end

  private

  def search_tags
    reports = tags ? Report.tags(tags) : Report.all
    @reports = paginate(reports.order('id desc'),
                        per_page: per_page)
  end

  def per_page
    @per_page ||= params.fetch(:per_page, 30)
  end

  def tags
    @tags ||= params[:tags]&.map(&:downcase)
  end
end
