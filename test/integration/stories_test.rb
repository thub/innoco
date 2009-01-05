require File.dirname(__FILE__) + '/../test_helper'

class StoriesTest < ActionController::IntegrationTest
  fixtures :all




  def test_multiple_users

    alpha = new_session
    beta = new_session
    
    alpha.goes_to_welcome_page  
    beta.goes_to_welcome_page
    
    alpha.enrols_with_email("a@alpha.com")
    beta.enrols_with_email("b@beta.com")
    
    alpha.logs_in
    beta.logs_in
    
    alpha.adds_proposal
    beta.adds_proposal
    
    alpha.updates_proposal
    beta.updates_proposal
    
    alpha.adds_comment
    beta.adds_comment
    
  end

  private


  def new_session
    open_session do |sess|
      sess.extend(TestingDSL)
      yield sess if block_given?
    end
  end

  module TestingDSL
    
    attr_reader :user    
    attr_reader :proposal
    
    def goes_to_welcome_page 
      get "/welcome"
      assert_response :success
    end

    def get_welcome_page_through_redirect
      get "/proposals"
      assert_redirected_to welcome_path
      follow_redirect!
      assert_response :success
    end


    def enrols_with_email(email)
      post "/users", :user=>{:email=>email}
      @user =  User.find_by_email(email)
      assert_not_nil @user
      assert_response :success
    end


    def logs_in
      get "/enter/#{@user.token}"
      assert_redirected_to "/proposals"
      follow_redirect!
      assert_response :success  
    end


    def adds_proposal
      post "/proposals",:proposal=>{:customer_requirement=>"Earn (more) money",:suggested_solution=>"Be smart"}
      assert_redirected_to proposals_path
      follow_redirect!
      assert_response :success
      @proposal = Proposal.find(:all).last
    end


    def updates_proposal
      put "/proposals/#{@proposal.id}" ,:proposal=>{:customer_requirement=>"kkk",:suggested_solution=>"kkkk"}
      follow_redirect!
      assert_response :success
      @proposal = Proposal.find(@proposal.id)
    end
    
    
    def adds_comment     
      post "/proposal/#{@proposal.id}/comment/create", :comment => {'id'=>'1','text' =>'test' }
      assert_redirected_to @proposal
    end
    
  end

end
