# frozen_string_literal: true

# Provides logic and interface for Users API
class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :require_admin, only: %i[index create destroy]
  before_action :require_same_user, only: %i[show update]

  def index
    @users = User.all
    render jsonapi: @users, status: :ok
  end

  def show
    render jsonapi: @user, status: :ok
  end

  def create
    @user = User.new(attributes(:user))

    if @user.save
      render jsonapi: @user, status: :created
    else
      render jsonapi_errors: @user.errors, status: :bad_request
    end
  end

  def update
    if @user.update(attributes(:user))
      render jsonapi: @user, status: :ok
    else
      render jsonapi_errors: @user.errors, status: :bad_request
    end
  end

  def destroy
    @user.destroy
    message = { message: "User #{@user.name} was deleted successfully" }
    render json: message, status: :ok
  end

  private

  def set_user
    @user = User.find(user_id)
    return render_not_found(:user) unless @user
  end

  def user_id
    params.fetch(:id)
  end

  def require_same_user
    return if current_user == @user
    require_admin
  end
end
