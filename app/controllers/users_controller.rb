class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show ]
  before_action :verify_admin, only: :destroy
  before_action :find_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate page: params[:page], per_page: 15
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".destroy"
      redirect_to users_url
    else
      flash[:danger] = t ".cannot_destroy"
      redirect_to @user
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
      flash[:danger] = t ".login"
      redirect_to login_url
    end
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t ".find"
      redirect_to root_url
    end
  end

  def correct_user
    redirect_to root_url unless current_user.is_user? @user
  end

  def verify_admin
    redirect_to root_url unless current_user.admin?
  end
end
