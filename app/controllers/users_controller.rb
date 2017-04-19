class UsersController < ApplicationController
  before_action :logged_in_user, :correct_user, only: [:edit, :update]
  before_action :find_user, only: [:show, :edit, :update]

   def index
    @users = User.paginate page: params[:page]
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
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = "Profile Update!"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
    :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
    #rescue ActiveRecord::RecordNotFound
    #flash[:dander] = "Your user_id: #{params[:id]} did not exist"
    #redirect_to root_url
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]
    unless @user.current_user? current_user
      flash[:danger] = "You cannot edit user_id: #{params[:id]}!"
      redirect_to @user
    end
  end
end
