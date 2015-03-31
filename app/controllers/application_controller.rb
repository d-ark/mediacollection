class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def forbidden
    if user_signed_in?
      render file: "#{Rails.root}/public/403.html", layout: false, status: 403
    else
      redirect_to new_user_session_path
    end
  end
end
