class Film < ApplicationRecord
  validates :title, presence: true
  validates :released, presence: true
  validates :runtime_min, presence: true, numericality: { greater_than: 0 }

  def self.new_from_omdb_api(ombd_api_json)
    res = Film.new
    res.released = Date.parse(ombd_api_json["Released"])
    res.released_on_dvd = Date.parse(ombd_api_json["DVD"])
    res.runtime_min = ombd_api_json["Runtime"].split(" ")[0]
    fields = ["Writer", "Actors", "Plot", "Language", "Country",
              "Awards", "Director", "Genre", "Rated", "Year", "Title", "Metascore", "imdbRating",
              "imdbID", "BoxOffice", "Production", "Website"]
    fields.each do |field|
      res[field.underscore] = ombd_api_json[field]
    end

    res.ratings = ombd_api_json["Ratings"].map {|i| i.map {|k, v| [k.downcase, v]}.to_h}

    res.poster_url = ombd_api_json["Poster"]
    res.film_type = ombd_api_json["Type"]
    res.imdb_votes = ombd_api_json["imdbVotes"].gsub(",", "")

    res
  end
end
