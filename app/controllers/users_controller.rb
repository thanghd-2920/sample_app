class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user.present?

    flash[:danger] = t"new.not_found", id: params[:id]
    redirect_to :home
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t"new.title"
      log_in @user
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
