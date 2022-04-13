require 'rails_helper'

RSpec.describe "categories/index", type: :view do
  before(:each) do
    assign(:categories, [
      Category.create!(
        name: "Name"
      ),
      Category.create!(
        name: "Name_2"
      )
    ])
  end

end
