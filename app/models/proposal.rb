class Proposal < ActiveRecord::Base
  
  belongs_to :owner, :class_name => "User"
  belongs_to :company, :class_name => "Company"
  
  has_many :comments,
  :foreign_key => 'regards_proposal_id',
  :class_name => 'Comment',
  :dependent => :destroy
  
end
