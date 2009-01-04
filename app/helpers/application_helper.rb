# Methods added to this helper will be available to all templates in the application.
require 'application_support'

module ApplicationHelper
  include ApplicationSupport
  
  # TODO: this is a duplicate of application controller method. Should be refactored in some way
  def current_user
     session[:current_user]
   end
  
  def user_logged_in?
    current_user!=nil
  end
  
end
