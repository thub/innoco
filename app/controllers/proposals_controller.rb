class ProposalsController < ApplicationController


  def index
    @proposals = current_user.company.proposals.paginate :order => 'id desc', :page => params[:page], :per_page =>10
    @proposal = Proposal.new
    @current_user = current_user
  end


  def show
    @proposal = Proposal.find(params[:id])
    unless user_can_be_shown_proposal(current_user,@proposal)
      redirect_to intruder_path
      return
    end
    @comments = @proposal.comments.paginate :order => 'id', :page => params[:page], :per_page =>10
    @comment = Comment.new
  end


  def edit
    @proposal = Proposal.find(params[:id])
    unless user_can_edit_proposal(current_user,@proposal)
      redirect_to intruder_path
      return
    end
  end


  def create
    @proposal = Proposal.new(params[:proposal])
    @proposal.owner = current_user
    @proposal.company = current_user.company
    logger.debug("Owner is #{@proposal.owner}")
    
    @proposal.display_id = @proposal.company.proposal_count
    @proposal.company.proposal_count += 1
    @proposal.company.save

    if @proposal.save
      flash[:notice] = 'Ditt bidrag ble registrert.'
      redirect_to proposals_path
      return
    else
      render :action => "new"
    end
  end


  def update
    @proposal = Proposal.find(params[:id])

    unless user_can_update_proposal(current_user,@proposal)
      redirect_to intruder_path
      return
    end

    orig_customer_requirement = @proposal.customer_requirement
    orig_suggested_solution = @proposal.suggested_solution

    if @proposal.update_attributes(params[:proposal])     
      logger.debug "modified at after"
      logger.debug @proposal.modified_at
      
      unless (orig_customer_requirement.eql? @proposal.customer_requirement) && (orig_suggested_solution.eql? @proposal.suggested_solution)
        logger.debug("setting modified at")
        @proposal.update_attribute(:modified_at,Time.now)
      end
      
      flash[:notice] = 'Ditt bidrag ble oppdatert.'
      redirect_to(@proposal)
      return
    else
      render :action => "edit"
    end
  end


  def destroy
    @proposal = Proposal.find(params[:id])

    unless user_can_destroy_proposal(current_user,@proposal)
      redirect_to intruder_path
      return
    end

    @proposal.destroy
    flash[:notice] = 'Ditt bidrag ble slettet.'
    redirect_to(proposals_url)
    return
  end

end

