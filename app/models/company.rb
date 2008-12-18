class Company < ActiveRecord::Base
  has_many :users,
   :foreign_key => 'company_id',
   :class_name => 'User'
  
   has_many :proposals,
     :foreign_key => 'company_id',
     :class_name => 'Proposal'
   
   #has_many :proposals , :through => :users
end
