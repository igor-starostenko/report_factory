# frozen_string_literal: true

# Provides logic and interface for Users API
class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :require_same_user, only: %i[show]
  before_action :require_admin, only: %i[create update destroy]

  USER_ATTRIBUTES = %i[name email password type].freeze

  def index
    @users = User.all
    render jsonapi: @users, status: :ok,
           fields: { user: %i[name email type date] }
  end

  def show
    render jsonapi: @user, status: :ok,
           fields: { user: %i[name email type api_key date] }
  end

  def login
    user_attributes = attributes(:user)
    @user = User.find_by(email: user_attributes[:email].downcase)
    if @user && @user.authenticate(user_attributes.fetch(:password))
      request.headers['X-API-KEY'] = @user.api_key
      redirect_to action: 'show', id: @user.id
    else
      render_unauthorized
    end
  end

  def create
    @user = Tester.new(attributes(:user))

    if @user.save
      render jsonapi: @user, status: :created,
             fields: { user: %i[name email type date] }
    else
      render jsonapi_errors: @user.errors, status: :bad_request
    end
  end

  def update
    if @user.update(attributes(:user))
      render jsonapi: @user, status: :ok,
             fields: { user: %i[name email type date] }
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
    @user = User.find(params.fetch(:id))
    return render_not_found(:user) unless @user
  end

  def require_same_user
    return if @auth_user == @user && @user
    render_unauthorized
  end
end
