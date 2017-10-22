class ReportsController < ApplicationController
  def index
    # render json: Report.where('owner_id = ?', @user.id)
  end

  def show
    # render json: @report
  end

  def create
    # if @report.present?
    #   render nothing: true, status: :conflict
    # else
    #   @report = Report.new
    #   @report.assign_attributes(@json['report']
    #   if @report.save
    #     render json: @report
    #   else
    #      render nothing: true, status: :bad_request
    #   end
    # end
  end
end
