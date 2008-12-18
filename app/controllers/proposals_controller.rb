class ProposalsController < ApplicationController


  def index
    @proposals = current_user.company.proposals.paginate :order => 'id desc', :page => params[:page], :per_page =>10
    @proposal = Proposal.new
    @current_user = current_user
  end


  def show
    @proposal = Proposal.find(params[:id])
    unless proposal_can_be_shown_to_current_user(@proposal)
      redirect_to intruder_path
      return
    end
    @comments = @proposal.comments.paginate :order => 'id', :page => params[:page], :per_page =>10
    @comment = Comment.new
  end


  def proposal_can_be_shown_to_current_user(proposal)
    proposal.owner.company == current_user.company || current_user.admin
  end


  def edit
    @proposal = Proposal.find(params[:id])
    unless @proposal.owner.id == current_user.id
      redirect_to intruder_path
      return
    end
  end


  def create
    @proposal = Proposal.new(params[:proposal])
    @proposal.owner = current_user
    @proposal.company = current_user.company
    logger.debug("Owner is #{@proposal.owner}")

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

    unless @proposal.owner.id == current_user.id
      redirect_to intruder_path
      return
    end

    orig_proposal = @proposal
    if @proposal.update_attributes(params[:proposal])     
      if text_has_changed(orig_proposal,@proposal) 
        @proposal.update_attribute(:modified_at,Time.now)
      end
      flash[:notice] = 'Ditt bidrag ble oppdatert.'
      redirect_to(@proposal)
      return
    else
      render :action => "edit"
    end
  end

  def text_has_changed(orig_proposal, new_proposal)
     @proposal.customer_requirement == orig_proposal.customer_requirement && @proposal.suggested_solution == orig_proposal.suggested_solution    
  end

  def destroy
    @proposal = Proposal.find(params[:id])

    unless @proposal.owner.id == current_user.id
      redirect_to intruder_path
      return
    end

    @proposal.destroy
    flash[:notice] = 'Ditt bidrag ble slettet.'
    redirect_to(proposals_url)
    return
  end

end

