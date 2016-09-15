require 'json'
require 'monetize'
require 'sequel'
require_relative './database_connection.rb'

DB.create_table :games do
  String :url
  String :name
  Integer :price
  Date :release_date
  String :icon_url
  Integer :review_score
  Integer :number_of_reviews
  Integer :metacritic
  String :developer
  String :publisher
  TrueClass :has_min_spec
  TrueClass :has_recommended_spec
  primary_key :id
end

DB.create_table :specs do
  String :OS
  String :CPU
  String :GPU
  String :RAM
  String :storage
  String :directx
  TrueClass :min_spec
  foreign_key :game_id
  primary_key :id
end
