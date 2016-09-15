require 'monetize'
require_relative '../db/database_connection.rb'
require_relative './game.rb'
require_relative './spec_factory.rb'

# Factory class for game objects
class GameFactory
  def initialize
    @spec_factory = SpecFactory.new
  end

  def parse_price(parsed_json, key)
    Monetize.parse(parse_string(parsed_json, key)).cents
  rescue
    nil
  end

  def parse_date(parsed_json, key)
    Date.parse(parse_string(parsed_json, key)).to_s
  rescue
    nil
  end

  def parse_string(parsed_json, key)
    parsed_json[key] ||= ''
  end

  def parse_int(parsed_json, key)
    parsed_json[key].to_i unless parsed_json[key].nil?
  end

  def validate_json(parsed_json)
    json = {}
    json[:url] = parse_string(parsed_json, :url)
    json[:name] = parse_string(parsed_json, :name)
    json[:price] = parse_price(parsed_json, :price)
    json[:release_date] = parse_date(parsed_json, :release_date)
    json[:icon_url] = parse_string(parsed_json, :icon_url)
    json[:review_score] = parse_int(parsed_json, :review_score)
    json[:number_of_reviews] = parse_int(parsed_json, :number_of_reviews)
    json[:metacritic] = parse_int(parsed_json, :metacritic)
    json[:developer] = parse_string(parsed_json, :developer)
    json[:publisher] = parse_string(parsed_json, :publisher)
    json[:has_min_spec] = false
    json[:has_recommended_spec] = false

    json
  end

  def create(parsed_json)
    json = validate_json(parsed_json)
    min_spec = @spec_factory.create(parsed_json[:min_spec], true)
    json[:has_min_spec] = true unless min_spec.nil?
    recommended_spec = @spec_factory.create(parsed_json[:recommended_spec], false)
    json[:has_recommended_spec] = true unless recommended_spec.nil?

    game = Game.create(json)
    game.add_spec(min_spec) if json[:has_min_spec]
    game.add_spec(recommended_spec) if json[:has_recommended_spec]

    game
  end

  def self.create(parsed_json)
    factory = GameFactory.new
    factory.create(parsed_json)
  end
end
