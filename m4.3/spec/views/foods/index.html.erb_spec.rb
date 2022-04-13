require 'rails_helper'

RSpec.describe 'foods/index', type: :view do
  let(:category) do
    FactoryBot.create(:category)
  end
  before(:each) do
    assign(:foods, [
             Food.create!(
               name: 'Name',
               description: 'Description',
               price: 2.5,
               category: category
             ),
             Food.create!(
               name: 'Name2',
               description: 'Description',
               price: 2.5,
               category: category
             )
           ])
  end

end
