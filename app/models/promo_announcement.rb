class PromoAnnouncement < ActiveRecord::Base
  belongs_to :link

  validates :link, presence: true
  validates :published_at, presence: true, if: -> { is_visible }
  validates :message, presence:true, allow_blank: false, if: :is_visible

  scope :latest, -> { where('published_at is not null').order(published_at: :desc) }

  before_validation :update_published_at

  def self.active
    return nil if latest.nil? || latest.empty?
    promo_announcement = latest.first
    return nil unless promo_announcement.link
    promo_announcement.visible? ? promo_announcement : nil
  end

  def visible?
    is_visible
  end

  private

  def update_published_at
    self.published_at = DateTime.now if is_visible
  end
end
