class SavedLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :link

  validates :user, presence: true
  validates :link, presence: true, uniqueness: { scope: :user, message: "You already have this link in your reading list" }
end
