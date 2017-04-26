class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
    only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "info.reset_pass"
      redirect_to root_url
    else
      flash.now[:danger] = t "danger.email_notfound"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty? ||
      params[:user][:password_confirmation].empty?
      @user.errors.add(:password, t("error.reset_pass"))
      render :edit
    elsif @user.update_attributes password_digest: User.digest(params)
      log_in @user
      flash[:success] = t "success.reset"
      redirect_to @user
    else
      flash[:danger] = t "danger.fail"
      render :edit
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    unless @user
      flash[:danger] = t "danger.emailnotfound"
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
      flash[:danger] = t "danger.expired"
      redirect_to new_password_reset_url
    end
  end
end
