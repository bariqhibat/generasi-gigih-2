require 'rails_helper'

RSpec.describe FoodsController do
  describe 'GET #index' do
    context 'with params[:letter]' do
      it 'populates an array of foods starting with the letter'
      it 'renders the :index template'
    end

    context 'without params[:letter]' do
      it 'populates an array of all foods'
      it 'renders the :index template'
    end
  end
  describe 'GET #show' do
    it 'assigns the requested food to @food'
    it 'renders the :show template'
  end
  describe 'GET #new' do
    it 'assigns a new Food to @food'
    it 'renders the :new template'
  end
end
