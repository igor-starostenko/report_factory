# frozen_string_literal: true

# Provides logic and interface for Rspec Reports API
class RspecReportsController < ApplicationController
  def index
    # render json: RspecReport.where('owner_id = ?', @project.name)
  end

  def show
    # render json: @rspec_report
  end

  def create
    # if @rspec_report.present?
    #   render nothing: true, status: :conflict
    # else
    #   @rspec_report = RspecReport.new
    #   @rspec_report.assign_attributes(@json['rspec_report']
    #   if @report.save
    #     render json: @rspec_report
    #   else
    #      render nothing: true, status: :bad_request
    #   end
    # end
  end
end
