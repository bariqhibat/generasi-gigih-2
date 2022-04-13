require 'rails_helper'

RSpec.describe "foods/index", type: :view do
  before(:each) do
    assign(:foods, [
      Food.create!(
        name: "Name",
        description: "Description",
        price: "Price",
        category: nil
      ),
      Food.create!(
        name: "Name",
        description: "Description",
        price: "Price",
        category: nil
      )
    ])
  end

  it "renders a list of foods" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Description".to_s, count: 2
    assert_select "tr>td", text: "Price".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
