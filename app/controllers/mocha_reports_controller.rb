# frozen_string_literal: true

# Provides logic and interface for Mocha Reports API
class MochaReportsController < ApplicationController
  before_action :set_mocha_reports, only: %i[index]

  def index
    render jsonapi: ensure_in_bounds(@mocha_reports), status: :ok
  end

  def show
    @mocha_report = MochaReport.all_details.find(params.fetch(:id))
    render jsonapi: @mocha_report, status: :ok
  end

  private

  def set_mocha_reports
    @mocha_reports = paginate(select_mocha_reports, per_page: per_page)
  end

  def select_mocha_reports
    mocha_reports = MochaReport.all_details
    tags ? mocha_reports.tags(tags) : mocha_reports
  end

  def per_page
    @per_page ||= params.fetch(:per_page, 30)
  end

  def tags
    @tags ||= params[:tags]&.map(&:downcase)
  end
end
