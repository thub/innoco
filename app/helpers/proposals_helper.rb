module ProposalsHelper
  
  def is_owner(proposal,user)
    proposal.owner == user
  end
end
