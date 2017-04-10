class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :admin_user, only: :destroy
  before_action :find_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate page: params[:page]
  end

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
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = "Profile Updated!"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = "User #{params[:id]} not found!"
      redirect_to root_path
    end
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
    unless @user.current_user? current_user
      flash[:danger] = "Bạn không được phép truy cập trang này"
      redirect_to root_path
    end
  end

  def admin_user
    unless current_user.is_admin?
      flash[:danger] = "Bạn không có quyền truy cập trang này"
      redirect_to users_path
    end
  end
end
