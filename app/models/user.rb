class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :saved_links
  has_many :links, through: :saved_links

  def save_link link
    saved_links.create(link: link)
  end

  def delete_link link
    saved_link = saved_links.find_by(link: link)
    saved_link.delete
  end

end
