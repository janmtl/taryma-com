class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout :layout_by_login
  
  private
  def not_authenticated
    redirect_to login_url, :alert => "First log in to view this page."
  end

  def layout_by_login
    if params[:controller]=="sessions"
      "sessions"
    elsif params[:controller]=="slides" && params[:action]=="browse"
      "slideshow"
    elsif logged_in? && !['browse', 'view', 'recent'].include?(params[:action])
      "admin"
    else
      "application"
    end
  end
end
