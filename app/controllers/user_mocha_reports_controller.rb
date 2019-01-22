# frozen_string_literal: true

# Provides interface for User Mocha Reports API
class UserMochaReportsController < BaseUsersController
  before_action :set_user, :set_user_mocha_reports

  def index
    render jsonapi: @user_mocha_reports, status: :ok,
           expose: { type: 'Mocha' }
  end

  private

  def set_user_mocha_reports
    @user_mocha_reports = join_user_mocha_reports
  end

  def join_user_mocha_reports
    UserReport.mocha.where(user_id: @user.id)
              .includes([:user, report: [:project, { reportable: :tests }]])
  end
end
