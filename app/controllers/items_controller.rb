class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.all
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
    end
end
