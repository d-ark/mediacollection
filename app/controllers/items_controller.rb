class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :new, :create, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :check_edit_access, only: [:edit, :update, :destroy]
  before_action :check_view_access, only: [:show]

  def index
    @my_items = Item.owned_by current_user
    @public_items = Item.published - @my_items
  end

  def show
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new item_params
    if @item.save
      redirect_to item_path(@item)
    else
      render :new
    end
  end

  def update
    if @item.update item_params
      redirect_to item_path(@item)
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path
  end

  private

    def set_item
      @item = Item.find params[:id]
    rescue ActiveRecord::RecordNotFound
      not_found
    end

    def check_view_access
      forbidden unless @item.can_view? current_user
    end

    def check_edit_access
      forbidden unless @item.can_edit? current_user
    end

    def item_params
      params.require(:item).permit(:title, :description, :kind, :link, :public)
            .merge(user_id: current_user.id)
    end
end
