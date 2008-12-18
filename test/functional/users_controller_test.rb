require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @controller = CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

  end

  def login
    @request.session[:current_user] = nil
    post '/enter',:token => '123'
    assert_not_nil @request.session[:current_user]
  end

  def login_other_user
    @request.session[:token] = nil
    post '/enter',:token => '456'
    assert_not_nil @request.session[:token]
  end


  test "should log in ok" do
    login
    
    @current_user = @request.session[:current_user]
    assert_not_nil @current_user
  end
  
  test "should have right email address" do
    login
    
    @current_user = @request.session[:current_user]
    assert "tjhubertz@gmail.com"==@current_user.email
  end
  
  
  test "should have non empty company" do
    login
    @current_user = @request.session[:current_user]
    
    assert_not_nil @current_user.company
  end
    
  
  
end
 