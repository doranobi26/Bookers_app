class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :introduction, length: { maximum: 50 }
  validates :name, length: { maximum: 20 }
  validates :name, length: { minimum: 2 }
  validates :name, presence: true
  attachment :profile_image

  has_many :books
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
  has_many :followings, through: :active_relationships, source: :follower
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :followers, through: :passive_relationships, source: :following

  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end

  def User.search(search, user_or_book, how_search)
    if user_or_book == "1"
      if how_search == "1"
                    User.where(['name LIKE ?', "%#{search}%"])
      elsif how_search == "2"
                    User.where(['name LIKE ?', "%#{search}"])
      elsif how_search == "3"
                    User.where(['name LIKE ?', "#{search}%"])
      elsif how_search == "4"
                    User.where(['name LIKE ?', "#{search}"])
      else
                    User.all
      end
    end
  end

end
