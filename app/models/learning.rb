class Learning < ApplicationRecord
  belongs_to :user
  belongs_to :app
  enum status: { "学習中": 0, "学習済み": 1, "学習中断": 2 }
end
