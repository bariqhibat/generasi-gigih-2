class AddCategoryItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :category, :string
    # add_column :items, :category, :string, :default => "food" 
  end
end
