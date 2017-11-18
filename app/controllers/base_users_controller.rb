# frozen_string_literal: true

# Abstract class that stores common behavior for all controllers
# that are routed from /api/v1/users
class BaseUsersController < ApplicationController
  private

  def set_user
    @user = User.find(params.fetch(:id))
    return render_not_found(:user) unless @user
  end

  def require_same_user
    return if @auth_user == @user && @user
    render_unauthorized
  end
end
