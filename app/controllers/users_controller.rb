class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :verify_admin, only: :destroy
  before_action :find_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate page: params[:page], per_page: 30
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "info.activate"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "success.update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "success.destroy"
      redirect_to users_url
    else
      flash[:danger] = t "danger.destroy"
      redirect_to users_url
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "danger.log_in"
      redirect_to login_url
    end
  end

  def correct_user
    unless current_user.is_user? @user
      flash[:danger] = t "danger.correct_user"
      redirect_to root_url
    end
  end

  def verify_admin
    unless current_user.admin?
      flash[:danger] = t "danger.admin_user"
      redirect_to root_url
    end
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "danger.find_user", param: params[:id]
      redirect_to root_url
    end
  end
end
