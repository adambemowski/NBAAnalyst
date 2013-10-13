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
      t.decimal :overunder_open
      t.decimal :overunder_close
      t.decimal :spread_open
      t.decimal :spread_close
      t.decimal :overunder_secondhalf
      t.decimal :spread_secondhalf

      t.timestamps
    end
  end
end
