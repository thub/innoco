# will be refactored when I get a more complete view of common functionality

class ApplicationSupport
  
  def ApplicationSupport.find_company_by_email(email)
      @company= Company.find_by_domain(get_domain(email))
      unless @company
        @company = Company.find_by_name('Demo')
      end
      return @company
  end

  private

  def ApplicationSupport.get_domain(email)
    domain = email.match(/\@(.+)/)[1]
  end
  
  def ApplicationSupport.generate_token
      ActiveSupport::SecureRandom.hex(50)
  end
  
  def ApplicationSupport.is_admin(email)
    get_domain(email)=="innoco.no" ||
    email=="hubertz.online.no"
  end
  
  def ApplicationSupport.valid_email(email)
    @email_format = Regexp.new(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/)
    @email_format.match(email)
  end
  
end