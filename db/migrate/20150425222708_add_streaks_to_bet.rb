class AddStreaksToBet < ActiveRecord::Migration
  def change
  	remove_column :bets, :timezones_traveled_from
  	remove_column :bets, :timezones_traveled_games
    remove_column :bets, :timezones_traveled_to

    add_column :bets, :consecutive_games_to,	:integer
    add_column :bets, :consecutive_games_from,	:integer
    add_column :bets, :consecutive_games_place, :string
    add_column :bets, :days_off_to, 			:integer
    add_column :bets, :days_off_from, 			:integer
    add_column :bets, :streak_to, 				:integer
    add_column :bets, :streak_from, 			:integer
    add_column :bets, :streak_place, 			:string
    add_column :bets, :streak_type, 			:string
  end
end
