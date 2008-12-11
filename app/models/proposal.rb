class Proposal < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"
  
  has_many :comments,
  :foreign_key => 'regards_proposal',
  :class_name => 'Comment'
  
end
