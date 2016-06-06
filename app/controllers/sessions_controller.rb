class SessionsController < ApplicationController
  before_filter :authenticated?, only: [:logout]
  before_filter :not_authenticated?, only: [:new, :create]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:password, :email))
    login_user = @user.authenticate
    if login_user
      session[:user_id] = login_user.id
      flash[:notice] = "Successful Login for " + login_user.name
      redirect_to '/'
    else
      flash[:notice] = "Invalid username or password"
      render "new"
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to '/'
  end
end
