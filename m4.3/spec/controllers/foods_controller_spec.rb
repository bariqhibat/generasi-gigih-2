require 'rails_helper'

RSpec.describe FoodsController do
  describe 'GET #show' do
    it 'assigns the requested food to @food' do
      food = create(:food)
      get :show, params: { id: food }
      expect(assigns(:food)).to eq food
    end

    it 'renders the :show template' do
      food = create(:food)
      get :show, params: { id: food }
      expect(response).to render_template :show
    end
  end

  describe 'GET #index' do
    context 'with params[:letter]' do
      it 'populates an array of foods starting with the letter' do
        nasi_uduk = create(:food, name: 'Nasi Uduk')
        kerak_telor = create(:food, name: 'Kelar Telor')
        get :index, params: { letter: 'N' }
        expect(assigns(:foods)).to match_array([nasi_uduk])
      end

      it 'renders the :index template' do
        get :index, params: { letter: 'N' }
        expect(response).to render_template :index
      end
    end

    context 'without params[:letter]' do
      it 'populates an array of all foods' do
        nasi_uduk = create(:food, name: 'Nasi Uduk')
        kerak_telor = create(:food, name: 'Kelar Telor')
        get :index
        expect(assigns(:foods)).to match_array([nasi_uduk, kerak_telor])
      end

      it 'renders the :index template' do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #new' do
    it 'assigns a new Food to @food' do
      get :new
      expect(assigns(:food)).to be_a_new(Food)
    end

    it 'renders the :new template' do
      get :new
      expect(:response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested food to @food' do
      food = create(:food)
      get :edit, params: { id: food }
      expect(assigns(:food)).to eq food
    end

    it 'renders the :edit template' do
      food = create(:food)
      get :edit, params: { id: food }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before :each do
      @category = create(:category)
    end
    context 'with valid attributes' do
      it 'saves the new food in the database' do
        expect  do
          post :create, params: { food: attributes_for(:food, category_id: @category.id) }
        end.to change(Food, :count).by(1)
      end

      it 'redirects to foods#show' do
        post :create, params: { food: attributes_for(:food, category_id: @category.id) }
        expect(response).to redirect_to(food_path(assigns[:food]))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new food in the database' do
        expect do
          post :create, params: { food: attributes_for(:invalid_food) }
        end.not_to change(Food, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { food: attributes_for(:invalid_food) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @food = create(:food)
    end

    context 'with valid attributes' do
      it 'locates the requested @food' do
        patch :update, params: { id: @food, food: attributes_for(:food) }
        expect(assigns(:food)).to eq @food
      end

      it "changes @food's attributes" do
        patch :update, params: { id: @food, food: attributes_for(:food, name: 'Nasi Uduk') }
        @food.reload
        expect(@food.name).to eq('Nasi Uduk')
      end

      it 'redirects to the food' do
        patch :update, params: { id: @food, food: attributes_for(:food) }
        expect(response).to redirect_to @food
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @food = create(:food)
    end

    it 'deletes the food from the database' do
      expect  do
        delete :destroy, params: { id: @food }
      end.to change(Food, :count).by(-1)
    end

    it 'redirects to foods#index' do
      delete :destroy, params: { id: @food }
      expect(response).to redirect_to foods_url
    end
  end
end
