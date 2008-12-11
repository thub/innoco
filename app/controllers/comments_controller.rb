class CommentsController < ApplicationController

  def edit
    @comment = Comment.find(params[:id])

    unless @comment.owner.id == current_user.id
      flash[:notice] = 'Hey stop it!'
      redirect_to @comment.regards_proposal
      return
    end

  end

  def create
    @comment = Comment.new(params[:comment])
    @proposal = Proposal.find(params[:regards_proposal_id])
    @comment.regards_proposal = @proposal  
    @comment.owner = current_user

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Din kommentar ble registrert.'
        format.html { redirect_to(@comment.regards_proposal) }
      else
        flash[:notice] = 'En feil oppstod. Kunne ikke registrere din kommentar'
        format.html { redirect_to(@comment.regards_proposal)}
      end
    end
  end

  def update
    @comment = Comment.find(params[:id])

    unless @comment.owner.id == current_user.id
      flash[:notice] = 'Hey stop it!'
      redirect_to @comment.proposal
      return
    end
    
    original_text = @comment.text
    
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        if @comment.text != original_text
          @comment.update_attribute(:modified_at,Time.now)
        end
        flash[:notice] = 'Din kommentar ble oppdatert'
        format.html { redirect_to(@comment.regards_proposal) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    unless @comment.owner.id == current_user.id
      flash[:notice] = 'Hey stop it!'
      redirect_to @comment.proposal
      return
    end
    
    @comment.destroy
    flash[:notice] = 'Din kommentar ble slettet'

    respond_to do |format|
      format.html { redirect_to(@comment.regards_proposal) }      
    end
  end
end
