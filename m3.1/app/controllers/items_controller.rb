class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    item = Item.create(item_params)

    redirect_to items_path
  end

  def edit
    @item = Item.find(params[:id])
  end

  def show
    @item = Item.find(params[:id])
    # rescue ActiveRecord::RecordNotFound => e
    # render 'missing_item'
  end

  def update
    @item = Item.find(params[:id])
    if @item
      @item.update(item_params)
    end
    redirect_to items_path
  end

  def destroy
    # Note that if the user has JavaScript disabled, the request will fall back to using GET.
    @item = Item.find(params[:id])
    if @item
      @item.destroy!
    end
    redirect_to items_path
  end

  private

  def item_params
    params.require(:item).permit(:name, :price)
  end
end
