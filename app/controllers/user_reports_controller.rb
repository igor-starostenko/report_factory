# frozen_string_literal: true

# Provides interface for User Reports API
class UserReportsController < BaseUsersController
  before_action :set_user

  def index
    render jsonapi: @user.user_reports, status: :ok
  end
end
