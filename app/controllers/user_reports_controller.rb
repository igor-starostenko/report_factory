# frozen_string_literal: true

# Provides interface for User Reports API
class UserReportsController < BaseUsersController
  before_action :set_user, :join_user_reports

  def index
    render jsonapi: @user_reports, status: :ok
  end

  private

  def fetch_user_reports
    UserReport.where(user_id: @user.id)
  end

  def join_user_reports
    @user_reports = fetch_user_reports.includes([:user, report: [:project]])
  end
end
