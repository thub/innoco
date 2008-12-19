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

    unless ApplicationSupport.valid_email(@user.email)
      flash.now[:alert] = "Ikke en gyldig epostaddresse"
      render :action=>"new"
      return
    end

    token = ApplicationSupport.generate_token

    existing_user = User.find_by_email(@user.email)
    if existing_user !=nil
      existing_user.token = token
      existing_user.save
      Mailer.deliver_existing_user_token_notification(exising_user)
      
      flash[:notice] = "Epost med lenke for å logge seg inn er sendt til #{existing_user.email}"

    else
      @user.token = token
      @user.company = ApplicationSupport.find_company_by_email(@user.email)
      if ApplicationSupport.is_admin(@user.email)
        @user.admin = true
      else
        @user.admin = false
      end
      logger.debug("the company #{@user.company}")
      if @user.save
        Mailer.deliver_new_user_token_notification(@user)            
        flash[:notice] = "Epost med lenke for å logge seg inn er sendt til #{@user.email}"       
      else
        flash[:alert] = "En feil oppstod."
        render :action => "new"       
        return
      end      
    end
  end


  def set_company
    if current_user.admin
      company = Company.find(params[:company_id])
      logger.debug("setting company for current user to #{company.name}")
      current_user.company = company
      redirect_to proposals_path
      return
    else
      redirect_to intruder_path
      return
    end
  end
  
  


end
