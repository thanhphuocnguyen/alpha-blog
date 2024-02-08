require 'test_helper'

class CreateCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: 'captain_ameria_1066', email: 'captain_ameria_1066@universe-1066.com',
                              password: 'password', admin: true)
    sign_in_as(@admin_user)
  end

  test 'get new category form and create category' do
    get '/categories/new'
    assert_response :success
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: 'Travel' } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'Travel', response.body
  end

  test 'invalid category submission results in failure' do
    get '/categories/new'
    assert_response :success
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: '' } }
    end
    assert_match 'errors', response.body
    assert_select 'div.alert'
    assert_select 'h3.alert-heading'
  end
end
