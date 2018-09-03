# frozen_string_literal: true

# Provides interface for User Reports API
class UserReportsController < BaseUsersController
  before_action :set_user, :set_user_reports

  def index
    render jsonapi: @user_reports, status: :ok
  end

  private

  def set_user_reports
    @user_reports = @user.user_reports.with_project
  end
end
