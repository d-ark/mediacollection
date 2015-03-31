class AddFieldPublicToItem < ActiveRecord::Migration
  def change
    add_column :items, :public, :boolean, null: false, default: false
  end
end
