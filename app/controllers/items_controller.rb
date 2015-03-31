class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :check_view_access, only: [:show]

  def index
    @my_items = Item.owned_by current_user
    @public_items = Item.published - @my_items
  end

  def show
  end

  def new
  end

  def edit
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
end
