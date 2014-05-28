class PromoAnnouncement < ActiveRecord::Base
  belongs_to :link

  validates :link, presence: true
  validates :published_at, presence: true, if: -> { is_visible }

  scope :latest, -> { where('published_at is not null').order(published_at: :desc).first }

  before_validation :update_published_at

  def self.active
    latest.visible? ? latest : nil
  end

  def visible?
    is_visible
  end

  private

  def update_published_at
    self.published_at = DateTime.now if is_visible
  end
end
