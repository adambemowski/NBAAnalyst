class PagesController < ApplicationController
  def home
            
  end
  
  def analyze
	  session[:data] = params[:bet_formula]

    redirect_to :controller => :pages, :action => :about
  end

  def about
  	@bet = Bet.new(session[:data])

    @bet.analyze!
  end

end
