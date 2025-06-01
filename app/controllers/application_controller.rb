class ApplicationController < ActionController::Base
  helper_method :permitted_params
  
  protect_from_forgery

  layout :layout_by_login

  private

  def logged_in?
    session[:user_id].present?
  end

  def not_authenticated
    redirect_to login_url, alert: "First log in to view this page."
  end

  def layout_by_login
    if params[:controller] == "sessions"
      "sessions"
    elsif params[:controller] == "slides" && params[:action] == "browse"
      "slideshow"
    elsif logged_in? && !['browse', 'view', 'recent'].include?(params[:action])
      "admin"
    else
      "application"
    end
  end

  def permitted_params
    params.permit(:sort, :direction, :page)
  end
end
