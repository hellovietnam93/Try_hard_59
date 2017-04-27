class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".flash.email_rs_pw"
      redirect_to root_url
    else
      flash.now[:danger] = t ".flash.email_not_found"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".error")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t ".flash.success_rs_pw"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    unless @user
      flash[:danger] = t "password_resets.cannot_find_email"
      redirect_to root_url
    end
  end

  def valid_user
    unless @user && @user.activated? && 
      @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t ".flash.email_rs_expire"
      redirect_to new_password_reset_url
    end
  end
end
