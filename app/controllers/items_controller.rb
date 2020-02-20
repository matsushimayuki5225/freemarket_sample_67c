class ItemsController < ApplicationController
  before_action :navi_parents, only: [:index]
  before_action :set_categories, only: [:index, :new, :create, :edit, :update]
  before_action :set_item, only: [:show]
  def index
    @items = Item.all.limit(5)
    @item = @items.includes(:user).order("created_at DESC")
  end

  def new
    @item = Item.new
    @item.images.build
    
    def get_category_children
      @category_children = Category.find(params[:parent_name]).children
    end
  
    def get_category_grandchildren
      @category_grandchildren = Category.find("#{params[:child_id]}").children
    end
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to root_path
  end

  def show
    @seller_id = User.find(@item.seller_id)
    @category = @item.category
  end

  private

  def set_categories
    @categories = Category.where(ancestry: nil)
    @category_parent_array = Category.pluck(:name)
  end

  def item_params
    params.require(:item).permit(:category_id, :brand, :title, :text, :condition_id, :prefecture_id, :fee_id, :deliveryday_id, :price, images_attributes: [:src]).merge(seller_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
