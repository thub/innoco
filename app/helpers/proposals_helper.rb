module ProposalsHelper
  
  def is_owner(proposal,user)
    proposal.owner == user
  end
  
  def number_of_comments(proposal)
    proposal.comments.size
  end
end
