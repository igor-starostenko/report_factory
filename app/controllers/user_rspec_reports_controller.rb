# frozen_string_literal: true

# Provides interface for User Rspec Reports API
class UserRspecReportsController < BaseUsersController
  before_action :set_user, :set_user_rspec_reports

  def index
    render jsonapi: @user_rspec_reports, status: :ok,
           expose: { type: 'Rspec' }
  end

  private

  def set_user_rspec_reports
    @user_rspec_reports = join_user_rspec_reports
  end

  def join_user_rspec_reports
    rspec_report_join = { reportable: [{ examples: :exception }, :summary] }
    UserReport.rspec.where(user_id: @user.id)
              .includes([:user, report: [:project, rspec_report_join]])
  end
end
