class Stock < ApplicationRecord
  belongs_to :user
  belongs_to :app
end
