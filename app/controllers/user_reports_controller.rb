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

  def rspec_param
    params[:details].to_s.casecmp?('rspec')
  end

  def join_user_reports
    @user_reports = fetch_user_reports.includes([:user, report: [:project]])
  end

  def join_user_rspec_reports
    rspec_report_join = [{ examples: :exception }, :summary]
    @user_reports = fetch_user_reports
      .includes([:user, report: [:project, { reportable: rspec_report_join }]])
  end
end
