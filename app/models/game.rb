# == Schema Information
#
# Table name: games
#
#  id                   :integer          not null, primary key
#  date                 :integer
#  visiting_team        :string(255)
#  visiting_1st         :integer
#  visiting_2nd         :integer
#  visiting_3rd         :integer
#  visiting_4th         :integer
#  visiting_score       :integer
#  visiting_moneyline   :integer
#  home_team            :string(255)
#  home_1st             :integer
#  home_2nd             :integer
#  home_3rd             :integer
#  home_4th             :integer
#  home_score           :integer
#  home_moneyline       :integer
#  overunder_open       :decimal(, )
#  overunder_close      :decimal(, )
#  spread_open          :decimal(, )
#  spread_close         :decimal(, )
#  overunder_secondhalf :decimal(, )
#  spread_secondhalf    :decimal(, )
#  created_at           :datetime
#  updated_at           :datetime
#

class Game < ActiveRecord::Base
end
