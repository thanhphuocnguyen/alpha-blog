require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  def setup
    @user = User.create(username: 'john', email: 'johndoe@example.com', password: 'password')
    @category = Category.create(name: 'Sports')
    @article = Article.new(title: 'Title test', description: 'Description test', user: @user, category_ids: [@category.id])
  end

  test "article should be valid" do
    assert @category.valid?
    assert @user.valid?
    assert @article.valid?
  end

  test "title should be present" do
    @article.title = " "
    assert_not @article.valid?
  end

  test "title should not be too short" do
    @article.title = "aa"
    assert_not @article.valid?
  end

  test "title should not be too long" do
    @article.title = "a" * 101
    assert_not @article.valid?
  end

  test "description should be present" do
    @article.description = " "
    assert_not @article.valid?
  end

  test "description should not be too short" do
    @article.description = "a" * 9
    assert_not @article.valid?
  end

  test "description should not be too long" do
    @article.description = "a" * 501
    assert_not @article.valid?
  end

  test "user_id should be present" do
    @article.user_id = nil
    assert_not @article.valid?
  end

  test "category_id should be in categories" do
    assert_raises(ActiveRecord::RecordNotFound) do
      @article.category_ids = [3]
      @article.save!
    end
  end
end
