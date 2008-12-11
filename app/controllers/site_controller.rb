class SiteController < ApplicationController
  skip_filter :check_token, :only =>[:welcome]  
  
  
  def welcome
     @user = User.new
   end
end
