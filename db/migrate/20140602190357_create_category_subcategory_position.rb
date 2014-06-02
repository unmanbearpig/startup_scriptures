class CreateCategorySubcategoryPosition < ActiveRecord::Migration
  def change
    create_table :category_subcategory_positions do |t|
      t.references :category, index: true
      t.references :subcategory, index: true
      t.integer :position
    end
  end
end
