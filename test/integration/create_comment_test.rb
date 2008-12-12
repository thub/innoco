require File.dirname(__FILE__) + '/../test_helper'
require 'comments_controller'
require 'proposals_controller'
require 'comment'

class CreateCommentTest < ActionController::IntegrationTest
  fixtures :all

  def test_creating_comment
     open_session do |user|
       assert_nil session[:token]
     end
    
  end
end
