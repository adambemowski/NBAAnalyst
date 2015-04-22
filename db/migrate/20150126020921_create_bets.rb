class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.string 	:bet_type
      t.string 	:bet_place
      t.integer :range_money_line_from
      t.integer :range_money_line_to
      t.integer :range_over_under_from
      t.integer :range_over_under_to
      t.integer :range_spread_from
      t.integer :range_spread_to
      t.integer :win_percentage_from
      t.integer :win_percentage_to
      t.integer :win_percentage_games
      t.string  :win_percentage_place
      t.integer :point_differential_from
      t.integer :point_differential_to
      t.integer :point_differential_games
      t.string  :point_differential_place
      t.integer :timezones_traveled_from
      t.integer :timezones_traveled_to
      t.integer :timezones_traveled_games
      t.integer :win_percentage
      t.integer :return_per_bet
      t.integer :number_of_games

      t.timestamps
    end
  end
end
