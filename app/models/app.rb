class App < ApplicationRecord
  belongs_to :user
  belongs_to :language
  has_many :learnings, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :reviews, dependent: :destroy
  acts_as_taggable

  attr_accessor :score

  def average_rate
    if reviews.present?
      reviews.average(:rate)
    else
      return "評価なし"
    end
  end

end
