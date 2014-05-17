class CreateUserCategorySubcategoryPositions < ActiveRecord::Migration
  def change
    create_table :user_category_subcategory_positions do |t|
      t.references :user, index: true
      t.references :category, index: true
      t.references :subcategory, index: true
      t.integer :position
    end
  end
end
