require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  before do
    @game = session[:game] || HangpersonGame.new('')
  end

  after do
    session[:game] = @game
  end

  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    word = params[:word] || HangpersonGame.get_random_word
    @game = HangpersonGame.new(word)
    redirect '/show'
  end


  post '/guess' do
    letter = params[:guess].to_s[0]
    begin
      new = @game.guess(letter)
    rescue ArgumentError
      flash[:message] = "Invalid guess"
    else
      flash[:message] = "You have already used that letter" if not new
    end
    redirect '/show'
  end

  get '/show' do
    if @game.check_win_or_lose == :win
      redirect '/win'
    elsif @game.check_win_or_lose == :lose
      redirect '/lose'
    else
      erb :show
    end
  end

  get '/win' do
    if @game.check_win_or_lose == :play
      redirect '/show'
    else
      erb :win
    end
  end

  get '/lose' do
    if @game.check_win_or_lose == :play
      redirect '/show'
    else
      erb :lose
    end
  end

end
