class Region < ApplicationRecord
  has_many :countries, dependent: :destroy
  has_many :articles, dependent: :nullify
  has_many :intelligence_reports, dependent: :destroy
end
