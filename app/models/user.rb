class User < ActiveRecord::Base
 
  has_many :proposals,
  :foreign_key => 'owner',
  :class_name => 'Proposal',
  :dependent => :destroy

  has_many :comments,
  :foreign_key => 'owner',
  :class_name => 'Comment',
  :dependent => :destroy          


end
