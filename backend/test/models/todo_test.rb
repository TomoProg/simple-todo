require "test_helper"

class TodoTest < ActiveSupport::TestCase
  test "is valid with a title and defaults to incomplete" do
    todo = Todo.new(title: "Buy milk")

    assert_predicate todo, :valid?
    assert_equal false, todo.completed
  end

  test "is invalid without a title" do
    todo = Todo.new(completed: false)

    assert_not todo.valid?
    assert_includes todo.errors[:title], "can't be blank"
  end

  test "is invalid when title is too long" do
    todo = Todo.new(title: "a" * 121)

    assert_not todo.valid?
    assert_includes todo.errors[:title], "is too long (maximum is 120 characters)"
  end
end
