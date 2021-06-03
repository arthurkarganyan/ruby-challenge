class CreateFilms < ActiveRecord::Migration[6.1]
  def change
    create_table :films do |t|
      t.string :title
      t.integer :year
      t.string :rated
      t.date :released
      t.integer :runtime_min
      t.string :genre
      t.string :director
      t.string :writer
      t.string :actors
      t.text :plot
      t.string :language
      t.string :country
      t.string :awards
      t.text :poster_url
      t.json :ratings
      t.integer :metascore
      t.float :imdb_rating
      t.integer :imdb_votes
      t.string :imdb_id
      t.string :film_type
      t.date :released_on_dvd
      t.string :box_office
      t.string :production
      t.string :website

      t.timestamps
    end
  end
end
