class StatJoin < ApplicationRecord
  belongs_to :model, polymorphic: true
  belongs_to :interval, polymorphic: true
  # belongs_to :period, -> { where(interval: {interval_type: 'Period'}) }, foreign_key: 'interval_id'
  # belongs_to :player, -> { where(models: {model_type: 'Player'}) }, foreign_key: 'model_id'
  has_many :stats
end
