class Season < ApplicationRecord
  has_many :teams, -> { order(:name) }, dependent: :destroy
  has_many :games, -> { includes(:season).order(:date) }, dependent: :destroy
  has_many :players, -> { includes(:team).order(:name) }, dependent: :destroy
  has_many :stats, dependent: :destroy
end
