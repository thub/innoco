require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase

  test "should log in ok" do
    login users(:alpha_user)
    @current_user = @request.session[:current_user]
    assert_not_nil @current_user
  end


  test "should have right email address" do
    login users(:alpha_user)
    @current_user = @request.session[:current_user]
    assert_equal users(:alpha_user).email,@current_user.email
  end


  test "should have non empty company" do
    login users(:alpha_user)
    @current_user = @request.session[:current_user]
    assert_not_nil @current_user.company
  end


  test "should fail email check" do
    post :create, :user=>{:email=>"this is not an email"}
    assert_equal 'Ikke en gyldig epostaddresse', flash[:alert] 
  end


  test "should pass email check" do
    post :create, :user=>{:email=>"this.is.valid@domain.com"}
    assert_response :success
  end


  test "should set current company" do
    login users(:admin_user)
    assert_equal companies(:demo_company).id,@request.session[:current_user].company.id
    post :set_company, :company_id => users(:beta_user).company.id
    assert_redirected_to proposals_path    
    assert_equal companies(:beta_company).id,@request.session[:current_user].company.id
  end


  test "should get redirected to intruder path" do
    login users(:alpha_user)
    post :set_company, :company_id => users(:beta_user).company.id
    assert_redirected_to intruder_path
  end


  test "should create user and send email" do
    email = "new.user@alpha.com"
    assert ActionMailer::Base.deliveries.empty?
    post :create, :user=>{:email=>email}
    assert !ActionMailer::Base.deliveries.empty?    
    sent = ActionMailer::Base.deliveries.first
    assert_equal [email], sent.to
    assert_equal "[#{SITE}] Lenke til å logge seg inn med", sent.subject
    @user =  User.find_by_email(email)
    assert_not_nil @user
    assert_response :success
  end

  test "should create user connected to alpha company" do
    email = "new.user@alpha.com"
    post :create, :user=>{:email=>email}
    @user =  User.find_by_email(email)
    assert_equal companies(:alpha_company).id , @user.company.id
    assert_response :success
  end

  test "should create user connected to demo company" do
    email = "new.user@somedomain.com"
    post :create, :user=>{:email=>email}
    @user =  User.find_by_email(email)
    assert_equal companies(:demo_company).id , @user.company.id
    assert_response :success
  end


  test "should create user with admin rights" do
    email = "new.user@innoco.no"
    post :create, :user=>{:email=>email}
    @user =  User.find_by_email(email)
    assert @user.admin
    assert_response :success
  end



  def login(user)
    get '/enter',:token => user.token
    assert_not_nil @request.session[:current_user]
  end

end

