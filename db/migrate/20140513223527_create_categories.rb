class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, nil: false, index: true

      t.timestamps
    end
  end
end
