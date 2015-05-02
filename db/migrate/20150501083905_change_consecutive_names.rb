class ChangeConsecutiveNames < ActiveRecord::Migration
  def change
    rename_column :bets, :consecutive_games_to, :consecutive_games_amount
    rename_column :bets, :consecutive_games_from, :consecutive_games_days
  end
end
