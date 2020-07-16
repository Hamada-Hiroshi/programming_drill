class App < ApplicationRecord
  belongs_to :user
  belongs_to :lang
  has_many :learnings, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :stocks, dependent: :destroy
  has_many :stock_users, through: :stocks, source: :user
  acts_as_taggable

  validates :title, presence: true, length: { maximum: 25 }, uniqueness: true
  validates :overview, presence: true
  validates :app_url, presence: true, format: /\A#{URI.regexp(%w(http https))}\z/
  validates :repo_url, presence: true, format: /\A#{URI.regexp(%w(http https))}\z/
  validates :function, presence: true
  validates :target, presence: true
  validates :status, inclusion: { in: [true, false] }

  attr_accessor :score

  def average_rate
    if reviews.present?
      reviews.average(:rate)
    else
      "評価なし"
    end
  end

  def stocked?(user)
    self.stock_users.include?(user)
  end
end
