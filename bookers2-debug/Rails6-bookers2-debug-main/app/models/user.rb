class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :validatable

  # has_many :books, dependent: :destroy
  # has_one_attached :profile_image
  # has_many :favorites, dependent: :destroy
  # has_many :book_comments, dependent: :destroy



  # has_many :relationships, foreign_key: :follower_id
  # has_many :followers, through: :relationships, source: :followed

  # has_many :reverse_of_relationships, class_name: 'Relationship',foreign_key: :followed_id
  # has_many :followeds, through: :reverse_of_relationships, source: :follower

  # validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  # validates :introduction, length: {maximum: 50}

   devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }



  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end




  def is_followed_by?(user)
    reverse_of_relationships.find_by(follower_id: user.id).present?
  end

  # def get_profile_image
  #   (profile_image.attached?) ? profile_image : 'no_image.jpg'
  # end

  # def get_profile_image(width, height)
  # unless profile_image.attached?
  #   file_path = Rails.root.join('app/assets/images/no_image.jpg')
  #   profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
  # end
  # profile_image.variant(resize_to_limit: [width, height]).processed
  # end

end
