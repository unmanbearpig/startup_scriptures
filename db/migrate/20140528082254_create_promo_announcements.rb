class CreatePromoAnnouncements < ActiveRecord::Migration
  def change
    create_table :promo_announcements do |t|
      t.references :link, index: true
      t.string :message
      t.boolean :is_visible

      t.timestamps
    end
  end
end
