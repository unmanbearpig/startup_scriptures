module BaseCategory
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true, allow_blank: false
  end
end
