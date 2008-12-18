class UsersController < ApplicationController
  skip_filter :check_token, :only =>[:new,:create]  

  def new
    @user = User.new
  end

  def show_proposals
    @user = current_user
    @proposals = current_user.proposals.paginate :order => 'id desc', :page => params[:page], :per_page =>10
  end

  def show_comments
    @user = current_user
    @comments = current_user.comments.paginate :order => 'id', :page => params[:page], :per_page =>10    
  end

  def create
    @user = User.new(params[:user])

    @email_format = Regexp.new(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/)

    unless @email_format.match(@user.email)
      flash.now[:alert] = "Ikke en gyldig epostaddresse"
      render :action=>"new"
      return
    end


    token = generate_token

    existing_user = User.find_by_email(@user.email)
    if existing_user !=nil
      existing_user.token = token
      existing_user.save
      send_token_email_to_existing_user existing_user
      flash[:notice] = "Epost med lenke for å logge seg inn er sendt til #{existing_user.email}"

    else
      @user.token = token
      @user.company = find_company(@user.email)
      if is_admin(@user.email)
        @user.admin = true
      else
        @user.admin = false
      end
      logger.debug("the company #{@user.company}")
      if @user.save
        send_token_email_to_new_user @user
        flash[:notice] = "Epost med lenke for å logge seg inn er sendt til #{@user.email}"       
      else
        flash[:alert] = "En feil oppstod."
        render :action => "new"       
        return
      end      
    end
  end

  def generate_token
    ActiveSupport::SecureRandom.hex(50)
  end

  def send_token_email_to_existing_user(user)  
    logger.info "Sending token to existing user #{user.token} to #{user.email}"
    Mailer.deliver_existing_user_token_notification(user)

  end

  def send_token_email_to_new_user(user)  
    logger.info "Sending token to new user #{user.token} to #{user.email}"
    Mailer.deliver_new_user_token_notification(user)    
  end

  def find_company(email)
    @company= Company.find_by_domain(get_domain(email))
    unless @company
      @company = Company.find_by_name('Demo')
    end
    return @company
  end

  def is_admin(email)
    get_domain(email)=="innoco.no" ||
    email=="hubertz.online.no"
  end

  def get_domain(email)
    domain = email.match(/\@(.+)/)[1]
  end

  def set_company
    if current_user.admin
      company = Company.find(params[:company_id])
      logger.debug("setting company for current user to #{company.name}")
      current_user.company = company
      redirect_to proposals_path
      return
    end
  end

end
