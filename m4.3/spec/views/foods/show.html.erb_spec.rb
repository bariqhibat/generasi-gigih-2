require 'rails_helper'

RSpec.describe "foods/show", type: :view do
  let(:category) do
    FactoryBot.create(:category)
  end
  before(:each) do
    @food = assign(:food, Food.create!(
      name: "Name",
      description: "Description",
      price: 2.5,
      category: category
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/#{category.id}/)
  end
end
