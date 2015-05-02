class ChangeDaysOffName < ActiveRecord::Migration
  def change
  	remove_column :bets, :days_off_to
  	rename_column :bets, :days_off_from, :days_off_amount
  end
end
