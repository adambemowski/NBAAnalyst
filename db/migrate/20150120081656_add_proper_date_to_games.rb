class AddProperDateToGames < ActiveRecord::Migration
  def up
  	add_column :games, :proper_date, :date, :after => :date
  end

  def down
  	remove_column :games, :proper_date
  end
end
