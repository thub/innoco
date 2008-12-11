class ProposalsController < ApplicationController

  def index
    @proposals = Proposal.find(:all)
    @proposal = Proposal.new

    respond_to do |format|
      format.html
    end
  end


  def show
    @proposal = Proposal.find(params[:id])
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
        flash[:notice] = 'Proposal was successfully created.'
        format.html { redirect_to(@proposal) }
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

    respond_to do |format|
      if @proposal.update_attributes(params[:proposal])
        flash[:notice] = 'Proposal was successfully updated.'
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

