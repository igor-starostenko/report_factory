# frozen_string_literal: true

# Provides logic and interface for Reports API
class ReportsController < ApplicationController
  def index
    @reports = Report.all
    render jsonapi: @reports, status: :ok
  end
end
