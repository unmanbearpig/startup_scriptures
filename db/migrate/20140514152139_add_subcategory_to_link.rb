class AddSubcategoryToLink < ActiveRecord::Migration
  def change
    add_reference :links, :subcategory, index: true
  end
end
