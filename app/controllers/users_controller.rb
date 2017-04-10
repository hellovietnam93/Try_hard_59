class UsersController < ApplicationController
  include ApplicationHelper
  include SessionsHelper

  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Updated success"
      redirect_to @user
    else
      render "edit"
    end
  end

  def find_user
    begin
      @user = User.find params[:id]
    rescue ActiveRecord::RecordNotFound => e
      @user = nil
    end
    if @user.nil?
      flash[:danger] = "User #{params[:id]} not found!"
      redirect_to root_path
    end
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in"
      redirect_to login_path
    end
  end

  def index
    @users = User.paginate page: params[:page]
  end

  def destroy
    @user.destroy
    flash[:success] = "Xoa user thanh cong"
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end

  def admin_user
    unless current_user.admin?
      flash[:danger] = "Ban khong co quyen truy cap trang nay"
      redirect_to users_path
    end
  end
end
