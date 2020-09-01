class Lang < ApplicationRecord
  attachment :lang_image
  has_many :apps
  validates :name, presence: true, uniqueness: true
end
