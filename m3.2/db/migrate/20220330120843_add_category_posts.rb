class AddCategoryPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :category, :string, :default => "food" 
  end
end
