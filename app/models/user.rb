class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attachment :profile_image
  has_many :apps
  has_many :learnings, dependent: :destroy
  has_many :questions
  has_many :reviews
  validates :name, presence: true, length: { maximum: 30 }
  validates :status, inclusion: { in: [true, false] }

  def active_for_authentication?
    super && (self.status == true)
  end
end
