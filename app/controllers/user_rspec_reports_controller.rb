# frozen_string_literal: true

# Provides interface for User Rspec Reports API
class UserRspecReportsController < BaseUsersController
  before_action :set_user, :join_user_rspec_reports

  def index
    render jsonapi: @user_reports, status: :ok,
      expose: { type: 'Rspec' }
  end

  private

  def fetch_user_reports
    UserReport.rspec.where(user_id: @user.id)
  end

  def join_user_rspec_reports
    rspec_report_join = [{ examples: :exception }, :summary]
    @user_reports = fetch_user_reports
      .includes([:user, report: [:project, { reportable: rspec_report_join }]])
  end
end
