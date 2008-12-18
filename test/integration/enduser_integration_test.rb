require File.dirname(__FILE__) + '/../test_helper'

class EnrolmentTest < ActionController::IntegrationTest
  fixtures :all

  
  def test_run
    @user = enrol("testme@online.no")
    login(@user)
    @proposal = add_proposal(@user)
    
    update_proposal(@proposal)
    
  end
  
  def enrol(email)
    get "/welcome"
    assert_response :success
    assert ActionMailer::Base.deliveries.empty?
    post "/users", :user=>{:email=>email}
    assert !ActionMailer::Base.deliveries.empty?    
    sent = ActionMailer::Base.deliveries.first
    assert_equal [email], sent.to
    assert_equal "[#{SITE}] Lenke til å logge seg inn med", sent.subject
    
    @user =  User.find_by_email(email)
    
    assert_not_nil @user
    
    assert_equal "Demo",@user.company.name
    
    assert_response :success
    return @user
    
  end


  def login(user)
    get enter_path(user.token)    

    assert_redirected_to "/proposals"

    follow_redirect!
    assert_response :success       
  end
  
  def add_proposal(user)
    post "/proposals",:proposal=>{:customer_requirement=>"Earn (more) money",:suggested_solution=>"Be smart"}
    assert_redirected_to proposals_path

    follow_redirect!
    assert_response :success
    
    @proposal = Proposal.find(:all).last
    
    assert_not_nil @proposal
    
    assert_equal @proposal.owner, user
    assert_nil @proposal.modified_at
    
    return @proposal
    
  end
  
  def update_proposal(proposal)
    put proposal_url(:id=>proposal.id),:proposal=>{:customer_requirement=>"kkk",:suggested_solution=>"kkkk"}
    assert_redirected_to proposal_path(proposal)
    follow_redirect!
    assert_response :success
    
    @proposal = Proposal.find(:all).last
    
    assert_not_nil @proposal.modified_at    
  end
      
end
