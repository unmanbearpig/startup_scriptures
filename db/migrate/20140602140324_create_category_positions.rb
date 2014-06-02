class CreateCategoryPositions < ActiveRecord::Migration
  def change
    create_table :category_positions do |t|
      t.references :category, index: true
      t.integer :position
    end
  end
end
