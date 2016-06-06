class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  helper_method :admin?

  def admin?
    if @current_user.role == "admin"
      return true
    else
      return false
    end
  end

  def authenticated?
    if session[:user_id]
      @current_user = User.find(session[:user_id])
      return true
    else
      redirect_to(:controller => "sessions", :action => "new")
      return false
    end
  end

  def not_authenticated?
    if !session[:user_id]
      return true
    else
      redirect_to "/"
    end
  end

  def is_admin?
    if @current_user.role == "admin"
      return true
    else
      flash[:message] = "Refrain from entering the admin area"
      redirect_to '/'
      return false
    end
  end
end
