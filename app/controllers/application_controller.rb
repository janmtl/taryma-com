class ApplicationController < ActionController::Base
  helper_method :permitted_params
  
  protect_from_forgery

  layout :layout_by_login

  private

  def layout_by_login
    if params[:controller] == "devise/sessions" # Updated for Devise
      "sessions"
    elsif params[:controller] == "slides" && params[:action] == "browse"
      "slideshow"
    elsif user_signed_in? && !['browse', 'view', 'recent'].include?(params[:action]) # Updated for Devise
      "admin"
    else
      "application"
    end
  end

  def permitted_params
    params.permit(:sort, :direction, :page)
  end
end
