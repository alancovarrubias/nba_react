class Season < ApplicationRecord
  has_many :teams, -> { order(:name) }, dependent: :destroy
  has_many :games, -> { includes(:away_team, :home_team).order("date") }, dependent: :destroy
  has_many :players, -> { order(:name) }, dependent: :destroy
  has_many :stats, as: :interval, dependent: :destroy
end
