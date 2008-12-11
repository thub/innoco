class User < ActiveRecord::Base
 
  has_many :proposals,
  :foreign_key => 'owner',
  :class_name => 'Proposal'

  has_many :comments,
  :foreign_key => 'owner',
  :class_name => 'Comment'          


end
