#require 'test_helper'
require File.dirname(__FILE__) + '/../test_helper'


# Re-raise errors caught by the controller.
class CommentsController; def rescue_action(e) raise e end; end

class CommentsControllerTest < ActionController::TestCase

  def setup
    @controller = CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

  end

  def login
    @request.session[:token] = nil
    post '/enter',:token => '123'
    assert_not_nil @request.session[:token]
  end

  def login_other_user
    @request.session[:token] = nil
    post '/enter',:token => '456'
    assert_not_nil @request.session[:token]
  end

  test "should create comment" do
    #def test_should_create_comment
    login
    assert_difference('Comment.count') do
      post :create, {:regards_proposal_id => 1,:comment => {'id'=>'1','text' =>'test' }}
      assert_response( :redirect )      
    end

    comment =  Comment.find_by_text('test');
    assert comment
    assert_redirected_to comment.regards_proposal 

  end

  test "should get edit" do
    login
    get :edit, :id => comments(:one).id
    assert_response :success
  end

  test "should not get edit" do
    login_other_user
    get :edit, :id => comments(:one).id
    assert_redirected_to intruder_path
  end

  test "should update comment" do
    login
    put :update, :id => comments(:one).id, :comment => { }
    assert_redirected_to comments(:one).regards_proposal
  end

  test "should not update comment" do
    login_other_user
    put :update, :id => comments(:one).id, :comment => { }
    assert_redirected_to intruder_path
  end

  test "should destroy comment" do
    login
    assert_difference('Comment.count', -1) do
      delete :destroy, :id => comments(:one).id
    end
    assert_redirected_to comments(:one).regards_proposal
  end

  test "should not destroy comment" do
    login_other_user
    delete :destroy, :id => comments(:one).id
    assert_redirected_to intruder_path    
  end

end
