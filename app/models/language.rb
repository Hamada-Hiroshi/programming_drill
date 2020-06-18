class Language < ApplicationRecord
  has_many :apps
  validates :name, presence: true, uniqueness: true
end
