class CreateCategorySubcategoryLinkPositions < ActiveRecord::Migration
  def change
    create_table :category_subcategory_link_positions do |t|
      t.references :category, index: true
      t.references :subcategory, index: true
      t.references :link, index: true
      t.integer :position
    end
  end
end
