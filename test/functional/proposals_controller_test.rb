require File.dirname(__FILE__) + '/../test_helper'

class ProposalsControllerTest < ActionController::TestCase

  test "should get index" do
    login users(:alpha_user)
    get :index
    assert_response :success
    assert_not_nil assigns(:proposals)
  end


  test "index should redirect to welcome when not logged in" do
    get :index 
    assert_redirected_to welcome_path
  end


  test "show should redirect to welcome when not logged in " do
    get :show, :id => proposals(:alpha_proposal).id
    assert_redirected_to welcome_path
  end


  test "should create proposal" do
    login users(:alpha_user)
    assert_difference('Proposal.count') do
      post :create, :proposal => {:customer_requirement => "Bla",:suggested_solution => "blabla" }
    end
    assert_redirected_to proposals_path
  end


  test "create should redirect to welcome when not logged in " do
    post :create, :proposal => {:customer_requirement => "Bla",:suggested_solution => "blabla" }
    assert_redirected_to welcome_path
  end


  test "should show alpha proposal to alpha user" do
    login users(:alpha_user)
    get :show, :id => proposals(:alpha_proposal).id
    assert_response :success
  end


  test "should not show alpha proposal to beta user" do
    login users(:beta_user)
    get :show, :id => proposals(:alpha_proposal).id
    assert_redirected_to intruder_path
  end


  test "should show alpha proposal to admin user" do
    login users(:admin_user)
    get :show, :id => proposals(:alpha_proposal).id
    assert_response :success
  end


  test "alpha user should get edit on alpha proposal" do
    login users(:alpha_user)
    get :edit, :id => proposals(:alpha_proposal).id
    assert_response :success
  end


  test "beta user should not get edit on alpha proposal" do
    login users(:beta_user)
    get :edit, :id => proposals(:alpha_proposal).id
    assert_redirected_to intruder_path
  end


  test "admin user should get edit on alpha proposal" do
    login users(:admin_user)
    get :edit, :id => proposals(:alpha_proposal).id
    assert_response :success
  end


  test "edit should redirect to welcome when not logged in" do
    get :edit, :id => proposals(:alpha_proposal).id
    assert_redirected_to welcome_path
  end


  test "update should redirect to welcome when not logged in" do 
    put :update, :id => proposals(:alpha_proposal).id, :proposal => {:customer_requirement => "fail", :suggested_solution => "fail" }
    assert_redirected_to welcome_path
  end


  test "alpha user should be able to update own proposal" do
    login users(:alpha_user)
    put :update, :id => proposals(:alpha_proposal).id, :proposal => {:customer_requirement => "fail", :suggested_solution => "fail" }
    assert_redirected_to proposal_path(proposals(:alpha_proposal))
    assert_equal 'Ditt bidrag ble oppdatert.', flash[:notice] 
    assert_not_nil Proposal.find(proposals(:alpha_proposal).id).modified_at    
  end


  test "should update modified_at" do
    login users(:alpha_user)
    assert_nil Proposal.find(proposals(:alpha_proposal).id).modified_at
    put :update, :id => proposals(:alpha_proposal).id, :proposal => {:customer_requirement => "otherd", :suggested_solution => "otherd" }
    assert Proposal.find(proposals(:alpha_proposal).id).modified_at!=nil
  end


  test "should not update modified_at when no text has changed" do
    login users(:alpha_user)
    assert_nil Proposal.find(proposals(:alpha_proposal).id).modified_at

    put :update, :id => proposals(:alpha_proposal).id, :proposal => {
      :customer_requirement => Proposal.find(proposals(:alpha_proposal).id).customer_requirement, 
      :suggested_solution => Proposal.find(proposals(:alpha_proposal).id).suggested_solution 
    }
    assert_nil Proposal.find(proposals(:alpha_proposal).id).modified_at    
  end


  test "alpha user should be able to destroy own proposal" do
    login users(:alpha_user)
    assert_difference('Proposal.count', -1) do
      delete :destroy, :id => proposals(:alpha_proposal).id
    end

    assert_redirected_to proposals_path
  end


  test "beta user should not be able to destroy alpha proposal" do
    login users(:beta_user)
    assert_no_difference('Proposal.count', -1) do
      delete :destroy, :id => proposals(:alpha_proposal).id
    end

    assert_redirected_to intruder_path
  end


  test "should create proposal with long text fields" do
    login users(:alpha_user)
    assert_difference('Proposal.count') do
      post :create, :proposal => {:customer_requirement => "c"*1000,:suggested_solution => "s"*1000 }
    end
    proposal = Proposal.find(:last)
    assert_equal 1000, proposal.customer_requirement.length
    assert_equal 1000, proposal.suggested_solution.length
  end

  test "should increment proposals display_id seperately for different companies" do
    login users(:alpha_user)
    post :create, :proposal => {:customer_requirement => "c",:suggested_solution => "s" }
    proposal = Proposal.find(:last)
    alpha_display_id = proposal.display_id
    
    
    login users(:beta_user)
    post :create, :proposal => {:customer_requirement => "c",:suggested_solution => "s" }
    proposal = Proposal.find(:last)
    beta_display_id = proposal.display_id
    
    login users(:alpha_user)
    post :create, :proposal => {:customer_requirement => "c",:suggested_solution => "s" }
    proposal = Proposal.find(:last)
    alpha_next_display_id = proposal.display_id

    login users(:beta_user)
    post :create, :proposal => {:customer_requirement => "c",:suggested_solution => "s" }
    proposal = Proposal.find(:last)
    beta_next_display_id = proposal.display_id
    
    assert_equal alpha_display_id+1,alpha_next_display_id
    assert_equal beta_display_id+1,beta_next_display_id
  end


  def login(user)
    get '/enter',:token => user.token
    assert_not_nil @request.session[:current_user]
  end

end
