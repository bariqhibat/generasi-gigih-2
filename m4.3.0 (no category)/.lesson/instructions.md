# Factories and TDD for Rails Controller

# Factory

In our previous lesson, you may have thought that it is too cumbersome to create test data, even after we use "context" and "before" block. For a programming framework that focuses on programmer happiness, there have to be other way to do it right?

## Fixtures

By default, Rails provides us with a means to quickly generate sample data called "fixtures". A fixture is formatted in YAML and looks like this:

```yaml
food1:
  name: "Nasi Uduk"
  description: "Betawi style steamed rice cooked in coconut milk. Delicious!"
  price: 10000.0
```

Once defined, we can referencing "food(:food1)" in a test and we will get new instance of "Food" with attributes set.

Fixtures, however, come with drawbacks:

- Fixtures can be brittle and easily broken, this will make us spending too much time maintaining our test data
- Fixtures bypass ActiveRecord when loaded into tests, this means that it ignores model validations that we actually need to test

## Factories

Thus came factories. Promised as simple and flexible building blocks for test data, factories have their own drawbacks too. We will discuss about them later. But for now, let's try it out.

To add factories to your specs for "Food" model, create a file named "spec/factories/food.rb" and fill it with these lines:

```ruby
FactoryBot.define do
  factory :food do
    name { "Nasi Uduk" }
    description { "Betawi style steamed rice cooked in coconut milk. Delicious!" }
    price { 10000.0 }
  end
end
```

Now, back to your `food_spec`, add this spec:

```ruby
RSpec.describe Food, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:food)).to be_valid
  end

  # some lines of code are not shown
end
```

Run `rspec -fd` to ensure your specs all pass.

## Refactor Your Spec to Use Factories

```ruby
require 'rails_helper'

RSpec.describe Food, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:food)).to be_valid
  end

  it 'is valid with a name and a description' do
    expect(FactoryBot.build(:food)).to be_valid
  end

  it 'is invalid without a name' do
    food = FactoryBot.build(:food, name: nil)
    food.valid?
    expect(food.errors[:name]).to include("can't be blank")
  end

  it "is invalid with a duplicate name" do
    food1 = FactoryBot.create(:food, name: 'Nasi Uduk')
    food2 = FactoryBot.build(:food, name: 'Nasi Uduk')

    food2.valid?

    expect(food2.errors[:name]).to include("has already been taken")
  end

  describe 'self#by_letter' do
    context 'with matching letter' do
      it "should return a sorted array of results that match" do
        food1 = FactoryBot.create(:food, name: 'Nasi Uduk')
        food2 = FactoryBot.create(:food, name: 'Kerak Telor')
        food3 = FactoryBot.create(:food, name: 'Nasi Semur Jengkol')
  
        expect(Food.by_letter("N")).to eq([food3, food1])
      end
    end
  end
end
```

Run `rspec -fd` to ensure your specs still work.

## Faker

Let's say that in one of your example, you need a lot of test data. For one or two test data for "Food" specs, you can easily google different names of food and their description. But what if you need 100 test data?

We can use Faker for that! Ported from Perl, Faker is a library for generating fake names, addresses, sentences, etc. You can see the complete list of things it can fake here: https://github.com/stympy/faker.

This is how you add faker to your factories:

```ruby
FactoryBot.define do
  factory :food do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    price { 10000.0 }
  end
end
```

As usual, run `rspec -fd` to ensure all your specs still work.

If you want to know what kind of names and descriptions Faker generates for your food, You can try to run this from your rails console. Execute "rails c test" to load your rails console in test environment. See what you get.

```
Faker::Food.dish
Faker::Food.ingredient
Faker::Food.spice
Faker::Food.measurement
Faker::Food.metric_measurement
```

## Drawbacks

We have mentioned earlier that factories have their drawbacks too. Unchecked factory usage, especially when we use association factories (which we have not used yet so far), factories can cause a test suite to slow down.

# TDD for Rails Controller

## Setup

Since Rails 5, some methods that we will use in our controller specs are now shipped as a different gem. We need to add it to our Gemfile.

```ruby
group :development, :test do
  # -cut-
  gem 'rails-controller-testing'
end
```

Don't forget to bundle install.

## Controller Spec

Put this in spec/controllers/foods_controller_spec.rb

```ruby
require 'rails_helper'

RSpec.describe FoodsController do
end
```

## Index

For "index" method, we want to create two contexts: one with "letter" params and one without "letter" params.

```ruby
require 'rails_helper'

describe FoodsController do
  describe 'GET #index' do
    context 'with params[:letter]' do
      it "populates an array of foods starting with the letter"
      it "renders the :index template"
    end

    context 'without params[:letter]' do
      it "populates an array of all foods"
      it "renders the :index template"
    end
  end
end
```

## Show

For "show" method, we want to make sure the controller shows the correct food data.

```ruby
require 'rails_helper'

describe FoodsController do
  # -cut-
  describe 'GET #show' do
    it "assigns the requested food to @food"
    it "renders the :show template"
  end
end
```

## New

For "new" method, we want to make sure the controller assigns a new empty instance of Food model.

```ruby
require 'rails_helper'

describe FoodsController do
  # -cut-
  describe 'GET #new' do
    it "assigns a new Food to @food"
    it "renders the :new template"
  end
end
```

## Edit

For "edit" method, we want to make sure the controller assigns a the correct instance of Food to @food.

```ruby
require 'rails_helper'

describe FoodsController do
  # -cut-
  describe 'GET #edit' do
    it "assigns the requested food to @food"
    it "renders the :edit template"
  end
end
```

## Create

For "create" method, we want to test for two contexts: one with valid attributes and another one with invalid attributes.

```ruby
require 'rails_helper'

describe FoodsController do
  # -cut-
  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new food in the database"
      it "redirects to foods#show"
    end

    context "with invalid attributes" do
      it "does not save the new food in the database"
      it "re-renders the :new template"
    end
  end
end
```

## Update

For "update" method, we want to test for two contexts: one with valid attributes and another one with invalid attributes.

```ruby
require 'rails_helper'

describe FoodsController do
  # -cut-
  describe 'PATCH #update' do
    context "with valid attributes" do
      it "locates the requested @food"
      it "changes @food's attributes"
      it "redirects to the food"
    end

    context "with invalid attributes" do
      it "does not update the food in the database"
      it "re-renders the :edit template"
    end
  end
end
```

## Destroy

For "destroy" method, we want to make sure that the deleted food is actually deleted from our database.

```ruby
require 'rails_helper'

describe FoodsController do
  # -cut-
  describe 'DELETE #destroy' do
    it "deletes the food from the database"
    it "redirects to foods#index"
  end
end
```

## Modify Factory

Our current Factory only contains one kind of test data for our `Food` model, the valid test data. To be able to specify more behaviors for our program, we need an invlaid test data. Let's add that to our Factory.

```ruby
FactoryBot.define do
  factory :food do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    price { 10000.0 }
  end

  factory :invalid_food, parent: :food do
    name nil
    description nil
    price 10000.0
  end
end
```

In the example above, we only created one invalid test data, the one in which the name and the description of the food is missing. When working with real projects, you might want to create different kind of invalid data. If you are working on an app to record students' grade, for instance, you might want to have one invalid data for students without NIM only, another one with wrong email format, and another one with no name. This is highly contextual and you should adjust accordingly to the business logic of your app.

## Testing GET Requests

### Specs for Show Method

We start from the easiest methods to test: the ones with get requests. They're `index`, `show`, `new`, and `edit`. For now, let's work on `show` method.

```ruby
describe FoodsController do
  # -cut-

  describe 'GET #show' do
    it "assigns the requested food to @food" do
      food = create(:food)
      get :show, params: { id: food }
      expect(assigns(:food)).to eq food
    end

    it "renders the :show template" do
      food = create(:food)
      get :show, params: { id: food }
      expect(response).to render_template :show
    end
  end

  # -cut-
end
```

### Specs for Index Method

Now, specs for `index` method.

```ruby
describe FoodsController do
  describe 'GET #index' do
    context 'with params[:letter]' do
      it "populates an array of foods starting with the letter" do
        nasi_uduk = create(:food, name: "Nasi Uduk")
        kerak_telor = create(:food, name: "Kelar Telor")
        get :index, params: { letter: 'N' }
        expect(assigns(:foods)).to match_array([nasi_uduk])
      end

      it "renders the :index template" do
        get :index, params: { letter: 'N' }
        expect(response).to render_template :index
      end
    end

    context 'without params[:letter]' do
      it "populates an array of all foods" do 
        nasi_uduk = create(:food, name: "Nasi Uduk")
        kerak_telor = create(:food, name: "Kelar Telor")
        get :index
        expect(assigns(:foods)).to match_array([nasi_uduk, kerak_telor])
      end

      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end
  end
  
  # -cut-
end
```

You should notice that our spec for `index` fails. Why? Because we have not updated controller:

```ruby
class FoodsController < ApplicationController
  # -cut-

  # GET /foods
  # GET /foods.json
  def index
    @foods = params[:letter].nil? ? Food.all : Food.by_letter(params[:letter])
  end

  # -cut-
end
```

### Specs for New Method

```ruby
describe FoodsController do
  # -cut-

  describe 'GET #new' do
    it "assigns a new Food to @food" do
      get :new
      expect(assigns(:food)).to be_a_new(Food)
    end

    it "renders the :new template" do
      get :new
      expect(:response).to render_template :new
    end
  end
  
  # -cut-
end
```

### Specs for Edit Method

```ruby
describe FoodsController do
  # -cut-

  describe 'GET #edit' do
    it "assigns the requested food to @food" do
      food = create(:food)
      get :edit, params: { id: food }
      expect(assigns(:food)).to eq food
    end

    it "renders the :edit template" do
      food = create(:food)
      get :edit, params: { id: food }
      expect(response).to render_template :edit
    end
  end
  
  # -cut-
end
```

## Testing POST Requests

To write specs for POST requests, we need to use FactoryBot's `attributes_for`.

### Specs for Create Method

```ruby
describe FoodsController do
  # -cut-

  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new food in the database" do
        expect{
          post :create, params: { food: attributes_for(:food) }
        }.to change(Food, :count).by(1)
      end

      it "redirects to foods#show" do
        post :create, params: { food: attributes_for(:food) }
        expect(response).to redirect_to(food_path(assigns[:food]))
      end
    end
    
    # -cut-
  end
  
  # -cut-
end
```

As for `create` method with invalid `food` attributes, we use slightly different specs:

```ruby
describe FoodsController do
  # -cut-

  describe 'POST #create' do
    # -cut-
    
    context "with invalid attributes" do
      it "does not save the new food in the database" do
        expect{
          post :create, params: { food: attributes_for(:invalid_food) }
        }.not_to change(Food, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { food: attributes_for(:invalid_food) }
        expect(response).to render_template :new
      end
    end
  end
  
  # -cut-
end
```

## Testing PATCH Requests

To test PATCH requests, we still use FactoryBot's `attributes_for` method with only slight difference on the specs.

```ruby
describe FoodsController do
  describe 'PATCH #update' do
    before :each do
      @food = create(:food)
    end

    context "with valid attributes" do
      it "locates the requested @food" do
        patch :update, params: { id: @food, food: attributes_for(:food) }
        expect(assigns(:food)).to eq @food
      end

      it "changes @food's attributes" do
        patch :update, params: { id: @food, food: attributes_for(:food, name: 'Nasi Uduk') }
        @food.reload
        expect(@food.name).to eq('Nasi Uduk')
      end

      it "redirects to the food" do
        patch :update, params: { id: @food, food: attributes_for(:food) }
        expect(response).to redirect_to @food
      end
    end
  end
end
```

Now for PATCH requests, with invalid attributes:

```ruby
describe FoodsController do
  describe 'PATCH #update' do
    before :each do
      @food = create(:food)
    end

    context "with valid attributes" do
      it "locates the requested @food" do
        patch :update, params: { id: @food, food: attributes_for(:food) }
        expect(assigns(:food)).to eq @food
      end

      it "changes @food's attributes" do
        patch :update, params: { id: @food, food: attributes_for(:food, name: 'Nasi Uduk') }
        @food.reload
        expect(@food.name).to eq('Nasi Uduk')
      end

      it "redirects to the food" do
        patch :update, params: { id: @food, food: attributes_for(:food) }
        expect(response).to redirect_to @food
      end
    end
  end
end
```

## Testing DELETE Requests

Lastly, to test DELETE requests, we can use:

```ruby
describe FoodsController do
  # -cut-
  describe 'DELETE #destroy' do
    before :each do
      @food = create(:food)
    end

    it "deletes the food from the database" do
      expect{
        delete :destroy, params: { id: @food }
      }.to change(Food, :count).by(-1)
    end

    it "redirects to foods#index" do
      delete :destroy, params: { id: @food }
      expect(response).to redirect_to foods_url
    end
  end
end
```
