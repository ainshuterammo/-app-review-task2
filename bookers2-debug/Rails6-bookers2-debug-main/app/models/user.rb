class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy



  has_many :relationships, foreign_key: :follower_id
  has_many :followers, through: :relationships, source: :followed

  has_many :reverse_of_relationships, class_name: 'Relationship',foreign_key: :followed_id
  has_many :followeds, through: :reverse_of_relationships, source: :follower



  # # フォローをした、されたの関係
  # has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # # 一覧画面で使う
  # has_many :followings, through: :relationships, source: :followed
  # has_many :followers, through: :reverse_of_relationships, source: :follower

  # def follow(user_id)
  #   relationships.create(followed_id: user_id)
  # end
  # # フォローを外すときの処理
  # def unfollow(user_id)
  #   relationships.find_by(followed_id: user_id).destroy
  # end
  # # フォローしているか判定
  # def following?(user)
  #   followings.include?(user)
  # end

  def self.looks(searches, words)
    if searches == "perfect_match"
      @user = User.where("name LIKE ?", "#{words}")
    else
      @user = User.where("name LIKE ?", "%#{words}%")
    end
  end



  def is_followed_by?(user)
    reverse_of_relationships.find_by(follower_id: user.id).present?
  end

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}




  # def get_profile_image
  #   (profile_image.attached?) ? profile_image : 'no_image.jpg'
  # end

  def get_profile_image(width, height)
  unless profile_image.attached?
    file_path = Rails.root.join('app/assets/images/no_image.jpg')
    profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
  end
  profile_image.variant(resize_to_limit: [width, height]).processed
  end

end
