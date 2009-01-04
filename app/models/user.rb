class User < ActiveRecord::Base
 
  has_many :proposals,
  :foreign_key => 'owner_id',
  :class_name => 'Proposal',
  :dependent => :destroy

  has_many :comments,
  :foreign_key => 'owner_id',
  :class_name => 'Comment',
  :dependent => :destroy          

  belongs_to :company, :class_name => "Company"

end
