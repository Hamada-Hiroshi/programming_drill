class App < ApplicationRecord
  belongs_to :user
  belongs_to :language
  has_many :learnings, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :reviews, dependent: :destroy
end
