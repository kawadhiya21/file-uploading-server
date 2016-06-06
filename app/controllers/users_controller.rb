class UsersController < ApplicationController
  before_filter :authenticated?, only: [:admin_area, :show]
  before_filter :is_admin?, only: [:admin_area, :show]
  before_filter :not_authenticated?, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:message] = "Account created successfully"
      redirect_to "/"
    else
      render "new"
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  public
  def admin_area
    @users = User.all
  end

  def show
    user = User.find(params[:id])
    @files = user.z_files
  end

end
