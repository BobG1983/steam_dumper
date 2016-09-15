require_relative './spec.rb'
# ORM class for scraped games
class Game < Sequel::Model
  one_to_many :specs
end
