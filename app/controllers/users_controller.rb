class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :check_user, only: %i(destroy update)
  before_action :correct_user, only: %i(edit update)
  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def show
    check_user
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "new.title"
      log_in @user
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    check_user
  end

  def update
    if @user.update(user_params)
      flash[:success] = t "user.update_success"
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    if @user.destroy
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
    check_user
    return if current_user?(@user)

    flash[:danger] = t "user.not_permit"
    redirect_to root_url
  end

  def check_user
    @user = User.find_by id: params[:id]
    return if @user.present?

    flash[:danger] = t "new.not_found", id: params[:id]
    redirect_to :home
  end
end
