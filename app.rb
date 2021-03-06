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
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
  if /^[A-Z]+$/i.match(letter) ## Only if the letter is in the alphabet.(A valid number.)
   
    if !@game.guess(letter) ## If the user already guessed the letter in this game.
       flash[:message] = "You have already used that letter." ## Output a flash message to notify the user.
    end
  else ## If the users guess is not in the alphabet.(Not a valid number.)
    flash[:message] = "Invalid guess." ## Output a flash message to notify the user.
  end
    
    redirect '/show'
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
   
     if @game.check_win_or_lose == :win ## If the game has been won.
        redirect '/win' ## Redirect the user to the win action.
    elsif  @game.check_win_or_lose == :lose ## If the game has been lost.
        redirect '/lose' ## Redirect the user to the lose action.
      end
    
    erb :show # You may change/remove this line
  end
  
  get '/win' do ## Modified to prevent cheating.
     if @game.check_win_or_lose == :win ## If the game has actually been won.
    erb :win ## Present the win view.
  else
    redirect '/show' ## Else redirect them back to the '/show' action.
    
  end
  end
  
  get '/lose' do ## Modified to prevent cheating.
   
     if @game.check_win_or_lose == :lose ## If the game has actually been lost.
    erb :lose # Present the lose view.
    else
    redirect '/show' ## Else redirect them back to the '/show' action.
  end
  end
  
end
