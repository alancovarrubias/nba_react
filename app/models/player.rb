class Player < ApplicationRecord
  belongs_to :team
  belongs_to :season
  has_many :stats, as: :statable, dependent: :destroy
  has_many :stat_joins, as: :model
  scope :by_minutes, -> { order("stats.sp DESC") }
  include PlayerStats

  def stat_hash
    stat.stat_hash
  end

  def opponent
    team.opponent
  end

  def predict_ortg(period)
    stats = Stat.where("statable_id = #{stat.player.id} AND intervalable_type = 'Period' AND intervalable_id IN (?)", period_ids).order("intervalable_id DESC").limit(num)
  end
end
