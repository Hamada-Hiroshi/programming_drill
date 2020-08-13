class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i(google_oauth2)
  attachment :profile_image

  has_many :apps
  has_many :learnings, dependent: :destroy
  has_many :questions
  has_many :reviews
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id, dependent: :destroy
  has_many :followings, through: :active_relationships, source: :follower
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :following
  has_many :active_notifications, class_name: "Notification", foreign_key: :visitor_id, dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: :visited_id, dependent: :destroy
  has_many :stocks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
  validates :status, inclusion: { in: [true, false] }

  def active_for_authentication?
    super && (status == true)
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  def self.guest
    find_or_create_by!(name: "ゲストユーザー", email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def self.admin
    find_or_create_by!(name: "管理者", email: "admin@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def self.without_sns_data(auth)
    user = User.where(email: auth.info.email).first
    if user.present?
      sns = SnsCredential.create(
        uid: auth.uid,
        provider: auth.provider,
        user_id: user.id
      )
    else
      user = User.new(
        name: auth.info.name,
        email: auth.info.email,
      )
      sns = SnsCredential.new(
        uid: auth.uid,
        provider: auth.provider
      )
    end
    { user: user, sns: sns }
  end

  def self.with_sns_data(auth, snscredential)
    user = User.where(id: snscredential.user_id).first
    if user.blank?
      user = User.new(
        name: auth.info.name,
        email: auth.info.email,
      )
    end
    { user: user }
  end

  def self.find_oauth(auth)
    uid = auth.uid
    provider = auth.provider
    snscredential = SnsCredential.where(uid: uid, provider: provider).first
    if snscredential.present?
      user = with_sns_data(auth, snscredential)[:user]
      sns = snscredential
    else
      user = without_sns_data(auth)[:user]
      sns = without_sns_data(auth)[:sns]
    end
    { user: user, sns: sns }
  end
end
