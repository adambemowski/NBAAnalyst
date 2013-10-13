class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :date
      t.string :visiting_team
      t.integer :visiting_1st
      t.integer :visiting_2nd
      t.integer :visiting_3rd
      t.integer :visiting_4th
      t.integer :visiting_score
      t.integer :visiting_moneyline
      t.string :home_team
      t.integer :home_1st
      t.integer :home_2nd
      t.integer :home_3rd
      t.integer :home_4th
      t.integer :home_score
      t.integer :home_moneyline
      t.integer :overunder_open
      t.integer :overunder_close
      t.integer :spread_open
      t.integer :spread_close
      t.integer :overunder_secondhalf
      t.integer :spread_secondhalf

      t.timestamps
    end
  end
end
