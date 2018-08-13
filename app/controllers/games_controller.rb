require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @attempt = params[:attempt]
    @letters = params[:letters]
    # @start_time = Time.parse(params[:start_time])
    # @end_time = Time.now
    @result = run_game(@attempt, @letters)
  end

def run_game(attempt, grid)
  dictionnary = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
  result = {}
  # duration = end_time - start_time
  if dictionnary["found"] && attempt_validation(attempt, grid)
    result[:score] = dictionnary["length"] * 10
    result[:message] = "Congratulations! #{attempt.upcase} is a valid English word"
  elsif !dictionnary["found"]
    result[:score] = 0
    result[:message] = "Sorry, but #{attempt.upcase} does not seem to be an english word"
  elsif !attempt_validation(attempt.upcase, grid)
    result[:score] = 0
    result[:message] = "Sorry, but #{attempt.upcase} can't be built out of #{grid}"
  end
  result
end

def attempt_validation(attempt, grid)
  attempt.chars.all? do |letter|
    attempt.count(letter) <= grid.count(letter.upcase)
  end
end

end
