class Team < ApplicationRecord
  belongs_to :season
  has_many :players
  has_many :stat_joins, as: :model
  has_many :stats, as: :statable, dependent: :destroy
end
