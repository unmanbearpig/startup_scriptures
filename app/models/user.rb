class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :saved_links
  has_many :links, through: :saved_links
  has_many :user_category_positions

  def save_link link
    saved_links.create(link: link)
  end

  def delete_link link
    saved_link = saved_links.find_by(link: link)
    saved_link.delete
  end

  def has_link? link
    saved_links.exists?(link: link)
  end

  def ordered_categories order = :asc
    fail InvalidArgument.new('Invalid order') unless %i(asc desc).include?(order)

    Category.joins("LEFT JOIN user_category_positions
ON user_category_positions.category_id = categories.id
AND user_category_positions.user_id = #{id}")
      .order("user_category_positions.position #{order}")
  end

  def category_position category
    UserCategoryPosition.find_by(user: self, category: category)
  end

  def set_category_order categories_array
    categories_array.each_index do |index|
      category = categories_array[index]
      position = index + 1
      category_positions.where(category: category)
        .first_or_create.update(position: position)
    end
  end

  def category_positions
    user_category_positions
  end
end
