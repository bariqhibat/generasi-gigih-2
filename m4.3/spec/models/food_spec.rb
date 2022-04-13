require 'rails_helper'

RSpec.describe Food, type: :model do
  let(:category) do
    return FactoryBot.create(:category)
  end
  subject(:food) do
    return FactoryBot.create(:food)
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:food)).to be_valid
  end

  it 'is valid with a name and a description' do
    expect(food).to be_valid
  end

  it 'is invalid without a category' do
    food.category = nil
    food.valid?
    expect(food.errors[:category]).to include('must exist')
  end

  it 'is invalid without a name' do
    food.name = nil
    food.valid?
    expect(food.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without a blank name' do
    food.name = ''
    food.valid?
    expect(food.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without a description' do
    food.description = nil
    food.valid?
    expect(food.errors[:description]).to include("can't be blank")
  end

  it 'is invalid without a blank description' do
    food.description = ''
    food.valid?
    expect(food.errors[:description]).to include("can't be blank")
  end

  it 'is invalid with a duplicate name' do
    food1 = Food.create(
      name: 'Nasi Uduk',
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price: 10_000.0,
      category: category
    )

    food2 = Food.new(
      name: 'Nasi Uduk',
      description: 'Just with a different description.',
      price: 10_000.0,
      category: category
    )

    food2.valid?

    expect(food2.errors[:name]).to include('has already been taken')
  end

  it 'is invalid with a non-integer price' do
    food.price = 'test_price'
    food.valid?

    expect(food.errors[:price]).to include('is not a number')
  end

  it 'is invalid with a price less than 0.01' do
    food.price = -5000.0
    food.valid?

    expect(food.errors[:price]).to include('must be greater than 0.01')
  end

  describe 'self#by_letter' do
    it 'should return a sorted array of results that match' do
      food1 = Food.create(
        name: 'Nasi Uduk',
        description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
        price: 10_000.0,
        category: category
      )

      food2 = Food.create(
        name: 'Kerak Telor',
        description: 'Betawi traditional spicy omelette made from glutinous rice cooked with egg and served with serundeng.',
        price: 8000.0,
        category: category
      )

      food3 = Food.create(
        name: 'Nasi Semur Jengkol',
        description: 'Based on dongfruit, this menu promises a unique and delicious taste with a small hint of bitterness.',
        price: 8000.0,
        category: category
      )

      expect(Food.by_letter('N')).to eq([food3, food1])
    end
  end

  describe 'self#by_category' do
    it 'should return foods that has the category' do
      new_category = Category.new(name: 'test_test')
      food2 = Food.create(
        name: 'Nasi Semur Jengkol',
        description: 'Based on dongfruit, this menu promises a unique and delicious taste with a small hint of bitterness.',
        price: 8000.0,
        category: new_category
      )

      expect(Food.by_category(category.name)).to eq([food])
      expect(Food.by_category(new_category.name)).to eq([food2])
    end
  end
end
