class Bet < ActiveRecord::Base

  attr_protected #makes all attributes accesible
  before_validation :init

  def init(h)
    h.each {|k,v| send("#{k}=",v)}
  end

  def analyze!
  	all_games = Game.all
    sum = 0
    wins = 0.0
    conforming_games_home = []
    conforming_games_away = []
    #Find all the games that conform to the bet

    #Add in all the home games to the mix
    if self.bet_place == 'any' || self.bet_place == 'home'
      conforming_games_home = all_games

      # Moneyline
      if !self.range_money_line_from.blank? && !self.range_money_line_to.blank?
        conforming_games_home = filterRange(conforming_games_home, :home_moneyline, self.range_money_line_from, self.range_money_line_to)
      end

      # Over Under
      if !self.range_over_under_from.blank? && !self.range_over_under_to.blank?
        conforming_games_home = filterRange(conforming_games_home, :overunder_close, self.range_over_under_from, self.range_over_under_to)
      end

      # Spread
      if !self.range_spread_from.blank? && !self.range_spread_to.blank?
        conforming_games_home = filterRange(conforming_games_home, :spread_close, self.range_spread_from, self.range_spread_to)
      end

      # Determine if the home moneyline games were a win or a loss
      if self.bet_type == 'moneyline'
        conforming_games_home.each do |g|
        if g.home_score > g.visiting_score
            sum += win_payoff(g.home_moneyline, 1000)
            wins += 1.0
          else
            sum -= 1000
          end
        end
      elsif self.bet_type == 'over'
        conforming_games_home.each do |g|
          if g.home_score + g.visiting_score == g.overunder_close
            # Tie nothing happens
          elsif g.home_score + g.visiting_score > g.overunder_close
            sum += win_payoff(-110, 1000)
            wins += 1.0
          else
            sum -= 1000
          end
        end
      elsif self.bet_type == 'under'
        conforming_games_home.each do |g|
          if g.home_score + g.visiting_score == g.overunder_close
            # Tie nothing happens
          elsif g.home_score + g.visiting_score < g.overunder_close
            sum += win_payoff(-110, 1000)
            wins += 1.0
          else
            sum -= 1000
          end
        end
      elsif self.bet_type == 'spread'
        conforming_games_home.each do |g|
          actual_spread = g.home_score - g.visiting_score
          if actual_spread.abs == g.spread_close
            # Tie nothing happens
          elsif g.home_moneyline < 0 && actual_spread > g.spread_close
            # Favored and beat the spread
            sum += win_payoff(-110, 1000)
            wins += 1.0
          elsif g.home_moneyline > 0 && actual_spread > -1*g.spread_close
            # Underdog and beat spread
            sum += win_payoff(-110, 1000)
            wins += 1.0
          else
            # Lost
            sum -= 1000
          end
        end                       
      end

    end

    #Add in all the away games to the mix
    if self.bet_place == 'any' || self.bet_place == 'away'
      conforming_games_away = all_games

      # MoneyLine
      if !self.range_money_line_from.blank? && !self.range_money_line_to.blank?
        conforming_games_away = filterRange(conforming_games_away, :visiting_moneyline, self.range_money_line_from, self.range_money_line_to)
      end

      # Over Under
      if !self.range_over_under_from.blank? && !self.range_over_under_to.blank?
        conforming_games_away = filterRange(conforming_games_away, :overunder_close, self.range_over_under_from, self.range_over_under_to)
      end

      # Spread
      if !self.range_spread_from.blank? && !self.range_spread_to.blank?
        conforming_games_away = filterRange(conforming_games_away, :spread_close, self.range_spread_from, self.range_spread_to)
      end

      # Determine if the home moneyline games were a win or a loss
      if self.bet_type == 'moneyline'
        conforming_games_away.each do |g|
          if g.home_score < g.visiting_score
            sum += win_payoff(g.visiting_moneyline, 1000)
            wins += 1.0
          else
            sum -= 1000
          end
        end
      elsif self.bet_type == 'over'
        conforming_games_away.each do |g|
          if g.home_score + g.visiting_score == g.overunder_close
            # Tie nothing happens
          elsif g.home_score + g.visiting_score > g.overunder_close
            sum += win_payoff(-110, 1000)
            wins += 1.0
          else
            sum -= 1000
          end
        end
      elsif self.bet_type == 'under'
        conforming_games_away.each do |g|
          if g.home_score + g.visiting_score == g.overunder_close
            # Tie nothing happens
          elsif g.home_score + g.visiting_score < g.overunder_close
            sum += win_payoff(-110, 1000)
            wins += 1.0
          else
            sum -= 1000
          end
        end
      elsif self.bet_type == 'spread'
        conforming_games_away.each do |g|
          actual_spread = g.visiting_score - g.home_score
          if actual_spread.abs == g.spread_close
            # Tie nothing happens
          elsif g.visiting_moneyline < 0 && actual_spread > g.spread_close
            # Favored and beat the spread
            sum += win_payoff(-110, 1000)
            wins += 1.0
          elsif g.visiting_moneyline > 0 && actual_spread > -1*g.spread_close
            # Underdog and beat spread
            sum += win_payoff(-110, 1000)
            wins += 1.0
          else
            # Lost
            sum -= 1000
          end
        end                       
      end

    end

    conforming_games = conforming_games_home + conforming_games_away
    if conforming_games.count > 0
      self.number_of_games = conforming_games.count
      self.return_per_bet = sum/(conforming_games.count)
      self.win_percentage = wins/conforming_games.count*100
    end

  end

  private

  def filterRange(games = [], key = nil, from = nil, to = nil)
  	returnGames = []
  	if from && to && key
  		#First make the range, making the inpts reversible
  		range = to < from ? to..from : from..to
  		returnGames = games.where(key => range)
  	end
  	return returnGames
  end


  def win_payoff(line = 100, bet_amount = 1000)
  	winnings = 0
  	if line >= 0
  		winnings = bet_amount*line/100
  	else
  		winnings = bet_amount*100/(-1*line)
  	end
  	return winnings
  end

end