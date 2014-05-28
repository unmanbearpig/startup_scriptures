class AddPublishedAtToPromoAnnouncements < ActiveRecord::Migration
  def change
    add_column :promo_announcements, :published_at, :datetime
  end
end
