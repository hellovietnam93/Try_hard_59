class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :verify_admin, only: :destroy
  before_action :load_user, except: [:index, :new, :create]
  before_action :verify_user, only: [:edit, :update]

  def index
    @users = User.select(:id, :name, :email).order(name: :asc)
      .paginate page: params[:page]
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
      log_in @user
      flash[:success] = t "users.welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.profile_updated"
      redirect_to @user
    else
      render :new
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.user_deleted"
    else
      flash[:danger] = t "users.delete_failed"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "users.login"
      redirect_to login_url
    end
  end

  def load_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "users.user_not_found"
      redirect_to root_url
    end
  end

  def verify_user
    redirect_to root_url unless @user.current_user? current_user
  end

  def verify_admin
    redirect_to root_url unless current_user.admin?
  end
end
