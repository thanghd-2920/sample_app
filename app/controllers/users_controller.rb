class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  def index
    @users = User.all
    @users = User.paginate(page:
      params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user.present?

    flash[:danger] = t "new.not_found", id: params[:id]
    redirect_to :home
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "mail.active_mess"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @user = User.find_by id: params[:id]
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      flash[:success] = t "user.update_success"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    if user&.destroy
      flash[:success] = t "user.delete_success"
    else
      flash[:danger] = t "user.delete_fail"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "user.log_in"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
