class ReportsController < ApplicationController
  def index
    # render json: Report.where('owner_id = ?', @project.name)
  end

  def show
    # render json: @report
  end
end
