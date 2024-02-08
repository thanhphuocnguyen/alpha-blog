require "test_helper"

class CreateArticleTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username: 'captain_ameria_1066', email: 'captain_ameria_1066@universe-1066.com',
                        password: 'password')
    @category = Category.create(name: 'Travel')
    sign_in_as(@user)
  end

  test 'get new article form and create article' do
    get '/articles/new'
    assert_response :success
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: 'Crisis on infinity earths',
                                               description: 'Crisis on infinity earths...',
                                               category_ids: [@category.id] } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'Crisis on infinity earths', response.body
  end

  test 'invalid article submission results in failure' do
    get '/articles/new'
    assert_response :success
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: '', description: '', category_ids: nil } }
    end
    assert_match 'errors', response.body
    assert_select 'div.alert'
    assert_select 'h3.alert-heading'
  end
end
