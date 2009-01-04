class CommentsController < ApplicationController


  def edit
    @comment = Comment.find(params[:id])

    unless user_can_edit_comment(current_user,@comment)
      redirect_to intruder_path
      return
    end

  end


  def create
    @comment = Comment.new(params[:comment])
    @proposal = Proposal.find(params[:regards_proposal_id])
    @comment.regards_proposal = @proposal  
    @comment.owner = current_user

    unless user_can_create_comment_regarding_proposal(current_user,@comment.regards_proposal)
      redirect_to intruder_path
      return
    end

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

    unless user_can_update_comment(current_user,@comment)
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
    
    unless user_can_destroy_comment(current_user,@comment)
      redirect_to intruder_path
      return
    end

    @comment.destroy
    flash[:notice] = 'Din kommentar ble slettet'
    redirect_to(@comment.regards_proposal)
    return
  end


end
