class ProposalsController < ApplicationController


  def index
    #@proposals = Proposal.find(:all,:order=>'id desc')
    @proposals = Proposal.paginate :order => 'id desc', :page => params[:page], :per_page =>10
    @proposal = Proposal.new

    respond_to do |format|
      format.html
    end
  end


  def show
    @proposal = Proposal.find(params[:id])
    @comments = Comment.paginate :conditions => ['regards_proposal_id = ?',@proposal.id], :order => 'id', :page => params[:page], :per_page =>10
    @comment = Comment.new
    respond_to do |format|
      format.html
    end
  end



  def edit
    @proposal = Proposal.find(params[:id])
    unless @proposal.owner.id == current_user.id
      flash[:notice] = 'Hey stop it!'
      redirect_to proposals_path
      return
    end
  end


  def create
    @proposal = Proposal.new(params[:proposal])
    @proposal.owner = current_user
    logger.debug("Owner is #{@proposal.owner}")

    respond_to do |format|
      if @proposal.save
        flash[:notice] = 'Ditt bidrag ble registrert.'
        format.html { redirect_to proposals_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @proposal = Proposal.find(params[:id])

    unless @proposal.owner.id == current_user.id
      flash[:notice] = 'Hey stop it!'
      redirect_to proposals_path
      return
    end
    
    original_customer_requirement = @proposal.customer_requirement
    original_suggested_solution = @proposal.suggested_solution

    respond_to do |format|
      if @proposal.update_attributes(params[:proposal])
        if @proposal.customer_requirement != original_customer_requirement || @proposal.suggested_solution != original_suggested_solution
          @proposal.update_attribute(:modified_at,Time.now)
        end
        flash[:notice] = 'Ditt bidrag ble oppdatert.'
        format.html { redirect_to(@proposal) }
      else
        format.html { render :action => "edit" }
      end
    end
  end


  def destroy
    @proposal = Proposal.find(params[:id])

    unless @proposal.owner.id == current_user.id
      flash[:notice] = 'Hey stop it!'
      redirect_to proposals_path
      return
    end

    @proposal.destroy


    respond_to do |format|
      format.html { redirect_to(proposals_url) }
    end
  end
  
end

