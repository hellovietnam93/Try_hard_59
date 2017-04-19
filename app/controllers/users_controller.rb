class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :admin_user, only: :destroy
  before_action :find_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.select(:id, :name, :email).where(activated: true)
      .order(created_at: :asc).paginate(page: params[:page], per_page: 15)
  end

  def show
    redirect_to root_url unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "info.activation"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
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
    @user.destroy
    flash[:success] = t "success.delete"
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
      flash[:danger] = t "danger.find_user", param: params[:id]
      redirect_to root_path
    end
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "danger.log_in"
      redirect_to login_url
    end
  end

  def correct_user
    unless @user.current_user? current_user
      flash[:danger] = t "danger.access"
      redirect_to root_path
    end
  end

  def admin_user
    unless current_user.is_admin?
      flash[:danger] = t "danger.access"
      redirect_to users_path
    end
  end
end
