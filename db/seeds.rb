# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

IMDB_IDS = %w(tt0232500 tt0322259 tt0463985 tt1013752 tt1596343 tt1905041 tt2820852 tt4630562)

IMDB_IDS.each do |i|
  existing_film = Film.find_by_imdb_id i
  if existing_film
    puts "Film #{existing_film.title} (IMDB_ID=#{i}) is already in the database, skipping..."
    next
  end

  api = OmdbApi.new
  json_data = api.film_info i
  new_film = Film.new_from_omdb_api json_data
  new_film.save!
  puts "Film (IMDB_ID=#{i}) #{new_film.title} saved!"
end