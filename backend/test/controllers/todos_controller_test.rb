require "test_helper"

class TodosControllerTest < ActionDispatch::IntegrationTest
  test "should get index ordered by newest first" do
    old_todo = Todo.create!(title: "First todo")
    new_todo = Todo.create!(title: "Second todo")

    get todos_url

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal [new_todo.id, old_todo.id], body.map { |item| item["id"] }
  end

  test "should create todo" do
    assert_difference("Todo.count", 1) do
      post todos_url, params: { todo: { title: "Write tests", completed: false } }, as: :json
    end

    assert_response :created
    body = JSON.parse(response.body)
    assert_equal "Write tests", body["title"]
    assert_equal false, body["completed"]
  end

  test "should not create todo without title" do
    assert_no_difference("Todo.count") do
      post todos_url, params: { todo: { title: "", completed: false } }, as: :json
    end

    assert_response :unprocessable_entity
  end

  test "should update todo completion" do
    todo = Todo.create!(title: "Update me", completed: false)

    patch todo_url(todo), params: { todo: { completed: true } }, as: :json

    assert_response :success
    assert_equal true, todo.reload.completed
  end

  test "should destroy todo" do
    todo = Todo.create!(title: "Delete me")

    assert_difference("Todo.count", -1) do
      delete todo_url(todo)
    end

    assert_response :no_content
  end
end
