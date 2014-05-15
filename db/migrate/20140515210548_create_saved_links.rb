class CreateSavedLinks < ActiveRecord::Migration
  def change
    create_table :saved_links do |t|
      t.references :user, index: true
      t.references :link, index: true

      t.timestamps
    end
  end
end
