class UsersController < ApplicationController
  before_action :find_user, except: [:new, :index, :create]
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def index
    @users = User.select(:name, :email, :id).paginate page: params[:page]
  end

  def show
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "user_controller.user_sign_up"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "user_controller.edit_info"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_controller.delete_user"
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
      flash[:danger] = t "user_controller.require_log_in"
      redirect_to login_url
    end
  end

  def find_user
    @user = User.find_by id: params[:id]
    if @user.nil?
      flash[:danger] = t "user_controller.cant_find_user"
      redirect_to root_url
    end
  end

  def correct_user
    redirect_to root_url unless current_user.is_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
