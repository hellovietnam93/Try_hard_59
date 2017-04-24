class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :admin_user, only: :destroy
  before_action :find_user, except: [:new, :index, :create]

  def index
    @users = User.select(:id, :name, :email).order(created_at: :desc)
      .paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = "Invalid email/password combination"
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    else
      flash[:danger] = "User deleted false"
      redirect_to users_url
    end
  end
  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = " User #{params[:id]} not found "
      redirect_to root_url
    end
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
