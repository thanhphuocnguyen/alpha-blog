require "test_helper"

class SignUpTest < ActionDispatch::IntegrationTest
  test 'create new user and redirect to listing articles page' do
    get '/signup'
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: 'dummy', email: 'dummyemail123@example.com', password: 'password' } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'Welcome to alpha blog dummy. You have successfully created new account.', response.body
  end

  test 'invalid user submission results in failure' do
    get '/signup'
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: '', email: '', password: '' } }
    end
    assert_match 'errors', response.body
    assert_select 'div.alert'
    assert_select 'h3.alert-heading'
  end
end
