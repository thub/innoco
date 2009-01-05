require File.dirname(__FILE__) + '/../test_helper'


# Re-raise errors caught by the controller.
class CommentsController; def rescue_action(e) raise e end; end

class CommentsControllerTest < ActionController::TestCase

  def login(user)
    get '/enter',:token => user.token
    assert_not_nil @request.session[:current_user]
  end


  test "should create comment" do
    login users(:alpha_user)
    assert_difference('Comment.count') do
      post :create, {:regards_proposal_id => proposals(:alpha_proposal).id,:comment => {'id'=>'1','text' =>'test' }}
      assert_response( :redirect )      
    end

    comment =  Comment.find_by_text('test');
    assert comment
    assert_redirected_to comment.regards_proposal 
  end


  test "should create comment and text should be set" do
    login users(:alpha_user)
    post :create, {:regards_proposal_id => proposals(:alpha_proposal).id,:comment => {'id'=>'1','text' =>'test' }}   
    comment =  Comment.find_by_text('test');
    assert comment
    assert_redirected_to comment.regards_proposal 
  end


  test "should not create comment" do
    login users(:alpha_user)
    post :create, {:regards_proposal_id => proposals(:beta_proposal),:comment => {'id'=>'1','text' =>'test' }}
    assert_redirected_to intruder_path      
  end  


  test "should get edit" do
    login users(:alpha_user)
    get :edit, :id => comments(:alpha_comment).id
    assert_response :success
  end


  test "should not get edit" do
    login users(:beta_user)
    get :edit, :id => comments(:alpha_comment).id
    assert_redirected_to intruder_path
  end


  test "should update comment" do
    login users(:alpha_user)
    put :update, :id => comments(:alpha_comment).id, :comment => { }
    assert_redirected_to comments(:alpha_comment).regards_proposal
  end


  test "should not update comment" do
    login users(:beta_user)
    put :update, :id => comments(:alpha_comment).id, :comment => { }
    assert_redirected_to intruder_path
  end


  test "should destroy comment" do
    login users(:alpha_user)
    assert_difference('Comment.count', -1) do
      delete :destroy, :id => comments(:alpha_comment).id
    end
    assert_redirected_to comments(:alpha_comment).regards_proposal
  end


  test "should not destroy comment" do
    login users(:beta_user)
    delete :destroy, :id => comments(:alpha_comment).id
    assert_redirected_to intruder_path    
  end

  test "should create comment with more than 256 characters" do
    login users(:alpha_user)
    post :create, {:regards_proposal_id => proposals(:alpha_proposal).id,:comment => {'id'=>'1','text' =>"t"*1000 }}   
    comment =  Comment.find(:last);
    assert_equal 1000, comment.text.length
    assert_redirected_to comment.regards_proposal 
  end
  
end