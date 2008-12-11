class ApplicationController < ActionController::Base
    
  helper :all
  
  before_filter :check_token
  
  #def rescue_action_in_public(exception)
  #    render :text => "<html><body><p>doh!</p> <!--  #{exception}  --></body></html>"
  #end
  
  
  def local_request?
    false
  end
  
  
  def hello
     render :text => I18n.localize( Time.now, :format => :short )
     return
   end
  
  
  def check_token
    if token_is_on_request?
      
      if token_matches_a_user?       
        set_token_in_session
        redirect_to :controller=>"Proposals", :action=>"index" 
      else
        flash[:notice] = "Du bruker tilsynelatende en gammel link for å logge deg på. Du kan motta en ny link ved å legge inn din epostaddresse under"        
        redirect_to welcome_path
      end
      
      return
    elsif token_is_in_session?
      # do nothing
    else
      redirect_to welcome_path 
      return
    end
  end
  
  def token_is_in_session?
    session[:token]!=nil  
  end

  def token_is_on_request?
    params[:token]!=nil
  end
  
  def set_token_in_session
    session[:token] = params[:token]
  end      
  
  def token_matches_a_user?
    User.find_by_token(params[:token])!=nil
  end
  
  def current_user
    User.find_by_token(session[:token])
  end
  
  def user_logged_in?
    current_user!=nil
  end
  
  def logout
    session[:token]=nil
  end

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '0e2c99506654cadd00f747e3b301d6e2'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
end
