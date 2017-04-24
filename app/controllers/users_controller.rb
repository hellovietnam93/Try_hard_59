class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :is_admin, only: :destroy
  before_action :find_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.select(:id, :name, :email).order(:name).paginate page: params[:page]
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".flash.checkemail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".flash.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".flash.users_destroyed"
      redirect_to users_url
    else
      flash[:danger] = t ".flash.cant_destroy"
      redirect_to @user
    end
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
    if @user.nil?
      redirect_to root_url
      flash[:danger] = t ".flash.cant_find_user"
    end
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation,
      :birthday, :phone
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t ".flash.loggin_first"
      redirect_to login_url
    end
  end

  def correct_user
    redirect_to root_url unless @user.is_user? @user
  end

  def is_admin
    redirect_to root_url unless current_user.admin?
  end
end
