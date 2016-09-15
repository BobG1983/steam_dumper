require_relative './game.rb'
# ORM class for scraped specificatons
class Spec < Sequel::Model
  one_to_one :game
end
