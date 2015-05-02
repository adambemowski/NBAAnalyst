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

      # Win % in last X games
      if !self.win_percentage_from.blank? && !self.win_percentage_to.blank? && !self.win_percentage_games.blank?
        conforming_games_home = filterWinPercentInLastXGames(conforming_games_home, self, 'home')
      end

      # Point differential in last X games
      if !self.point_differential_from.blank? && !self.point_differential_to.blank? && !self.point_differential_games.blank?
        conforming_games_home = filterPointDifferentialInLastXGames(conforming_games_home, self, 'home')
      end

      # Consecutive games
      if !self.consecutive_games_amount.blank? && !self.consecutive_games_days.blank?
        conforming_games_home = filterConsecutiveGames(conforming_games_home, self, 'home')
      end

      # Days Off
      if !self.days_off_amount.blank?
        conforming_games_home = filterDaysOff(conforming_games_home, self, 'home')
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

      # Win % in last X games
      if !self.win_percentage_from.blank? && !self.win_percentage_to.blank? && !self.win_percentage_games.blank?
        conforming_games_away = filterWinPercentInLastXGames(conforming_games_away, self, 'away')
      end

      # Point differential in last X games
      if !self.point_differential_from.blank? && !self.point_differential_to.blank? && !self.point_differential_games.blank?
        conforming_games_away = filterPointDifferentialInLastXGames(conforming_games_away, self, 'away')
      end

      # Consecutive games
      if !self.consecutive_games_amount.blank? && !self.consecutive_games_days.blank?
        conforming_games_away = filterConsecutiveGames(conforming_games_away, self, 'away')
      end

      # Days Off
      if !self.days_off_amount.blank?
        conforming_games_away = filterDaysOff(conforming_games_away, self, 'away')
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


  def filterWinPercentInLastXGames(games = [], bet = nil, place = nil)
    returnGames = []
    games.each do |g|
      # Get the team name and find the previous games
      team_name = place == 'home' ? g.home_team : g.visiting_team
      range = previousGames(g, team_name, bet.win_percentage_games, bet.win_percentage_place)
      # Calculate the win percentage
      wins = 0.0
      range.each do |r|
        if (r.home_team == team_name && r.home_score > r.visiting_score) || (r.visiting_team == team_name && r.home_score < r.visiting_score)
          wins += 1.0
        end
      end

      # Add game to return games if it satisfies the win percentage
      win_percentage = (wins/bet.win_percentage_games) * 100
      if win_percentage.between?(bet.win_percentage_from, bet.win_percentage_to) || win_percentage.between?(bet.win_percentage_to, bet.win_percentage_from)
        returnGames << g
      end
    end

    return returnGames
  end


  def filterPointDifferentialInLastXGames(games = [], bet = nil, place = nil)
    returnGames = []
    games.each do |g|
      # Get the team name and find the previous games
      team_name = place == 'home' ? g.home_team : g.visiting_team
      range = previousGames(g, team_name, bet.point_differential_games, bet.point_differential_place)
      # Calculate the win percentage
      total_point_diff = 0.0
      range.each do |r|
        if r.home_team == team_name
          total_point_diff += r.home_score - r.visiting_score
        else
         total_point_diff += r.visiting_score - r.home_score
        end
      end

      # Add game to return games if it satisfies the win percentage
      point_diff_avg = (total_point_diff/bet.point_differential_games)
      if point_diff_avg.between?(bet.point_differential_from, bet.point_differential_to) || point_diff_avg.between?(bet.point_differential_to, bet.point_differential_from)
        returnGames << g
      end
    end

    return returnGames
  end


  def filterConsecutiveGames(games = [], bet = nil, place = nil)
    returnGames = []
    games.each do |g|
      # Get the team name and find the previous games
      team_name = place == 'home' ? g.home_team : g.visiting_team
      range = previousGames(g, team_name, bet.consecutive_games_amount, bet.consecutive_games_place)

      last_game = range.last
      # If the range holds enough games, and the last game in the set is within the range add it to the list
      if range.count == bet.consecutive_games_amount && last_game && (last_game.proper_date >= (g.proper_date - bet.consecutive_games_days.days))
        returnGames << g
      end
    end

    return returnGames
  end


  def filterDaysOff(games = [], bet = nil, place = nil)
    returnGames = []
    games.each do |g|
      # Get the team name and find the previous games
      team_name = place == 'home' ? g.home_team : g.visiting_team
      range = previousGames(g, team_name, 1, 'any')

      last_game = range.first
      # If the range holds enough games, and the last game in the set is within the range add it to the list
      if last_game && (last_game.proper_date < (g.proper_date - bet.days_off_amount.days))
        returnGames << g
      end
    end

    return returnGames
  end


  def previousGames(game = nil, team_name = nil, amount = 0, place = 'home')
    if place == 'home'
      Game.where('proper_date < ? AND home_team = ?', game.proper_date, team_name).order("proper_date DESC").limit(amount)
    elsif place == 'away'
      Game.where('proper_date < ? AND visiting_team = ?', game.proper_date, team_name).order("proper_date DESC").limit(amount)
    elsif place == 'any'
      Game.where('proper_date < ? AND (visiting_team = ? OR home_team = ?)', game.proper_date, team_name, team_name).order("proper_date DESC").limit(amount)
      # Game.find(:all, :order => "proper_date desc", :limit => 5)
    end  
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