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
   
   def intruder
      render :text => "Du er logget på som #{current_user.email} og har utført en ulovlig operasjon"
      return
    end
  
  
  def check_token
    logger.debug "in check token"
    if token_is_on_request?
      
      if token_matches_a_user?       
        set_user_in_session
        redirect_to :controller=>"Proposals", :action=>"index" 
      else
        flash[:notice] = "Du bruker tilsynelatende en gammel link for å logge deg på. Du kan motta en ny link ved å legge inn din epostaddresse under"        
        redirect_to welcome_path
      end
        
      return
    elsif user_is_in_session?
      logger.debug "user in session #{current_user.email} connected to #{current_user.company.name}"
    else
      redirect_to welcome_path 
      return
    end
  end
  
  def user_is_in_session?
    session[:current_user]!=nil  
  end

  def token_is_on_request?
    params[:token]!=nil
  end
  
  def set_user_in_session
    session[:current_user] = User.find_by_token(params[:token])
  end      
  
  def token_matches_a_user?
    User.find_by_token(params[:token])!=nil
  end
  
  def current_user
       session[:current_user]
  end
  
  def user_logged_in?
    #return current_user!=nil
    return true
  end
  
  def current_user_is_admin?
    get_domain(current_user.email)=="innoco.no" || current_user.email=="hubertz.online.no"
  end

  def get_domain(email)
    domain = email.match(/\@(.+)/)[1]
  end
  
  def logout
    session[:current_user]=nil
  end

  
  
  
    
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '0e2c99506654cadd00f747e3b301d6e2'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
end
