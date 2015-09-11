require 'sinatra'
require './helpers/blackjack_helper.rb'

helpers Blackjack

enable :sessions

get '/' do

  session[:money] = 500
  erb :home

end

get '/bet' do

  deal_cards
  erb :bet, :locals => { :money => session[:money] }

end

get '/blackjack' do

  result = make_play
  erb :blackjack, :locals => { :player => session[:player], :result => result, :computer => session[:computer], :bet_value => session[:bet_value] }

end

