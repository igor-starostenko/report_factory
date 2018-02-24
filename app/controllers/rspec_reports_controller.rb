# frozen_string_literal: true

# Provides logic and interface for Rspec Reports API
class RspecReportsController < ApplicationController
  def index
    @rspec_reports = RspecReport.all
    render jsonapi: @rspec_reports, status: :ok
  end

  def show
    @rspec_report = RspecReport.find(params.fetch(:id))
    render jsonapi: @rspec_report, status: :ok
  end
end
