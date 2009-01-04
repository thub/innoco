class Comment < ActiveRecord::Base
  
  belongs_to :owner, :class_name => "User"
  belongs_to :regards_proposal, :class_name => "Proposal"
  
end
