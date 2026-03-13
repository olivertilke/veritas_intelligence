class Country < ApplicationRecord
  belongs_to :region
  has_many :articles, dependent: :nullify
end
