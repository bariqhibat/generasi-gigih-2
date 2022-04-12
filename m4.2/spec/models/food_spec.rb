require 'rails_helper'

RSpec.describe Food, type: :model do
  it 'is valid with a name and a description' do
    food = Food.new(
      name: 'Nasi Uduk',
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price: 15000.0
    )

    expect(food).to be_valid
  end

  it 'is invalid without a name' do
    food = Food.new(
      name: nil,
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price: 15000.0
    )

    food.valid?

    expect(food.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without a blank name' do
    food = Food.new(
      name: "",
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price: 15000.0
    )

    food.valid?

    expect(food.errors[:name]).to include("can't be blank")
  end
  
  it 'is invalid without a description' do
    food = Food.new(
      name: "Name",
      description: nil,
      price: 15000.0
    )

    food.valid?

    expect(food.errors[:description]).to include("can't be blank")
  end

  it 'is invalid without a blank description' do
    food = Food.new(
      name: "Name",
      description: '',
      price: 15000.0
    )

    food.valid?

    expect(food.errors[:description]).to include("can't be blank")
  end

  it "is invalid with a duplicate name" do
    food1 = Food.create(
      name: "Nasi Uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: 10000.0
    )
    
    food2 = Food.new(
      name: "Nasi Uduk",
      description: "Just with a different description.",
      price: 10000.0
    )

    food2.valid?
    
    expect(food2.errors[:name]).to include("has already been taken")
  end

  it "is invalid with a non-integer price" do
    food = Food.create(
      name: "Nasi Uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: "price"
    )

    food.valid?

    expect(food.errors[:price]).to include("is not a number")
  end

  it "is invalid with a price less than 0.01" do
    food = Food.create(
      name: "Nasi Uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: -0.001
    )

    food.valid?

    expect(food.errors[:price]).to include("must be greater than 0.01")
  end

  describe 'self#by_letter' do
    it "should return a sorted array of results that match" do
      food1 = Food.create(
        name: "Nasi Uduk",
        description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
        price: 10000.0
      )

      food2 = Food.create(
        name: "Kerak Telor",
        description: "Betawi traditional spicy omelette made from glutinous rice cooked with egg and served with serundeng.",
        price: 8000.0
      )

      food3 = Food.create(
        name: "Nasi Semur Jengkol",
        description: "Based on dongfruit, this menu promises a unique and delicious taste with a small hint of bitterness.",
        price: 8000.0
      )

      expect(Food.by_letter("N")).to eq([food3, food1])
    end
  end

end