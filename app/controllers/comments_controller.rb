class CommentsController < ApplicationController

  def edit
    @comment = Comment.find(params[:id])

    unless @comment.owner.id == current_user.id
      redirect_to intruder_path
      return
    end

  end

  def create
    @comment = Comment.new(params[:comment])
    @proposal = Proposal.find(params[:regards_proposal_id])
    @comment.regards_proposal = @proposal  
    @comment.owner = current_user

    if @comment.save
      flash[:notice] = 'Din kommentar ble registrert.'
      redirect_to(@comment.regards_proposal)
      return
    else
      flash[:notice] = 'En feil oppstod. Kunne ikke registrere din kommentar'
      redirect_to(@comment.regards_proposal)
      return
    end
  end

  def update
    @comment = Comment.find(params[:id])

    unless @comment.owner.id == current_user.id
      redirect_to intruder_path
      return
    end

    original_text = @comment.text

    if @comment.update_attributes(params[:comment])
      if @comment.text != original_text
        @comment.update_attribute(:modified_at,Time.now)
      end
      flash[:notice] = 'Din kommentar ble oppdatert'
      redirect_to(@comment.regards_proposal)
      return
    else
      render :action => "edit"        
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    unless @comment.owner.id == current_user.id
      redirect_to intruder_path
      return
    end

    @comment.destroy
    flash[:notice] = 'Din kommentar ble slettet'
    redirect_to(@comment.regards_proposal)
    return

  end
end
