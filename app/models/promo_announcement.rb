class PromoAnnouncement < ActiveRecord::Base
  belongs_to :link

  validates :link, presence: true
  validates :published_at, presence: true, if: -> { is_visible }
  validates :message, presence:true, allow_blank: false, if: :is_visible

  scope :latest, -> { where('published_at is not null').order(published_at: :desc) }

  after_save :update_published_at

  def self.active
    return nil unless promo = latest.first
    promo.visible? ? promo : nil
  end

  def visible?
    is_visible
  end

  def is_visible
    self == self.class.latest.first && read_attribute(:is_visible)
  end


  def update_published_at
    self.update(published_at: DateTime.now) if read_attribute(:is_visible) && !visible?
  end
end
