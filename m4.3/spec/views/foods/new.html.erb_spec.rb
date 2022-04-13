require 'rails_helper'

RSpec.describe "foods/new", type: :view do
  before(:each) do
    assign(:food, Food.new(
      name: "MyString",
      description: "MyString",
      price: "MyString",
      category: nil
    ))
  end

  it "renders new food form" do
    render

    assert_select "form[action=?][method=?]", foods_path, "post" do

      assert_select "input[name=?]", "food[name]"

      assert_select "input[name=?]", "food[description]"

      assert_select "input[name=?]", "food[price]"

      assert_select "input[name=?]", "food[category_id]"
    end
  end
end
