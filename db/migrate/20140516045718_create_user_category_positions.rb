class CreateUserCategoryPositions < ActiveRecord::Migration
  def change
    create_table :user_category_positions do |t|
      t.references :user, index: true
      t.references :category, index: true
      t.integer :position

      t.timestamps
    end
  end
end
