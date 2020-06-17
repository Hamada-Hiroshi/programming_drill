class App < ApplicationRecord
  belongs_to :user
  belongs_to :language
  has_many :learnings, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :reviews, dependent: :destroy
  acts_as_taggable

  validates :language_id, acceptance: true
  validates :title, presence: true, length: { maximum: 25 }, uniqueness: true
  validates :overview, presence: true
  validates :app_url, presence: true, format: /\A#{URI::regexp(%w(http https))}\z/
  validates :repo_url, presence: true, format: /\A#{URI::regexp(%w(http https))}\z/
  validates :function, presence: true
  validates :target, presence: true
  validates :status, inclusion: { in: [true, false] }

  attr_accessor :score

  def average_rate
    if reviews.present?
      reviews.average(:rate)
    else
      return "評価なし"
    end
  end

end
