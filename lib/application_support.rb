# will be refactored when I get a more complete view of common functionality

module ApplicationSupport
  
  def find_company_by_email(email)
      @company= Company.find_by_domain(get_domain(email))
      unless @company
        @company = Company.find_by_name('Demo')
      end
      return @company
  end

  private

  def get_domain(email)
    domain = email.match(/\@(.+)/)[1]
  end
  
  def generate_token
      ActiveSupport::SecureRandom.hex(50)
  end
  
  def is_admin(email)
    get_domain(email)=="innoco.no" ||
    email=="hubertz.online.no"
  end
  
  def valid_email(email)
    @email_format = Regexp.new(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/)
    @email_format.match(email)
  end
  
  def user_can_be_shown_proposal(user,proposal)
    (proposal.company == user.company) || user.admin
  end
  
  def user_can_edit_proposal(user,proposal)
    (proposal.owner == user) || user.admin
  end
  
  def user_can_update_proposal(user,proposal)
    (proposal.owner == user) || user.admin
  end

  def user_can_destroy_proposal(user,proposal)
    (proposal.owner == user) || user.admin
  end
  
  def user_can_create_comment_regarding_proposal(user,proposal)
    (proposal.company.id == current_user.company.id) || user.admin   
  end
  
  def user_can_edit_comment(user,comment)
     (comment.owner.id == current_user.id)  || user.admin
  end
  
  def user_can_update_comment(user,comment)
    (comment.owner.id == current_user.id)  || user.admin
  end
  
  def user_can_destroy_comment(user,comment)
     (comment.owner.id == current_user.id)  || user.admin
  end
  
end