require 'json'
require 'steam_scraper'
require 'benchmark'
require 'zaru'
require_relative './utility/zip_file_generator.rb'
require_relative './models/game_factory.rb'

def scrape
  scraper = SteamScraper::SteamScraper.new
  results = scraper.scrape

  results.each do |game|
    filename = Zaru.sanitize! game[:name]
    file = File.open('./json/' + Date.new.to_s + filename + '.json', 'w')
    file.puts JSON.generate(game)
    file.close
  end
end

def zip
  directory_to_zip = './json'
  output_file = './' + Date.new.to_s + 'steam_store_json.zip'
  zf = ZipFileGenerator.new(directory_to_zip, output_file)
  zf.write
end

def dump_to_db
  scraped_games = Dir.glob('./json/*.json')
  scraped_games.each do |scraped_game|
    contents = File.open(scraped_game, 'r').read
    parsed_contents = JSON.parse(contents, symbolize_names: true)
    GameFactory.create(parsed_contents)
  end
  puts 'Total Games in DB: ' + Game.all.length.to_s
end
