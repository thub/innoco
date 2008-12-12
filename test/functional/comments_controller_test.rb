#require 'test_helper'
require File.dirname(__FILE__) + '/../test_helper'


# Re-raise errors caught by the controller.
class CommentsController; def rescue_action(e) raise e end; end

class CommentsControllerTest < Test::Unit::TestCase

  def setup
    @controller = CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

  end

  def login
    assert_nil @request.session[:token]
    post '/enter',:token => '123'
    assert_not_nil @request.session[:token]
  end

  def test_should_create_comment
    login
    assert_difference('Comment.count') do
      post :create, {:regards_proposal_id => 1,:comment => {'id'=>'1','text' =>'test' }}
      assert_response( :redirect )      
    end

    comment =  Comment.find_by_text('test');
    assert comment
    assert_redirected_to comment.regards_proposal 

  end

  #  test "should get edit" do
  #    get :edit, :id => comments(:one).id
  #    assert_response :success
  #  end

  #  test "should update comment" do
  #    put :update, :id => comments(:one).id, :comment => { }
  #    assert_redirected_to comment_path(assigns(:comment))
  #  end

  #  test "should destroy comment" do
  #    assert_difference('Comment.count', -1) do
  #      delete :destroy, :id => comments(:one).id
  #    end

  #    assert_redirected_to comments_path
  #  end
end
