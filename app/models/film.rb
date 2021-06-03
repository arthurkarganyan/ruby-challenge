class Film < ApplicationRecord
  validates :title, presence: true
  validates :released, presence: true
  validates :runtime_min, presence: true, numericality: {greater_than: 0}

  has_many :show_times
  has_many :film_reviews

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

  TIMESLOTS_TIME = 15.minutes
  ADS_TIME = 15.minutes

  def show_time_duration
    overall_time = (runtime_min.minutes + ADS_TIME)

    x = (overall_time % TIMESLOTS_TIME > 0) ? 1 : 0
    (overall_time / TIMESLOTS_TIME + x) * TIMESLOTS_TIME
  end

  def avg_rating
    res = film_reviews.average(:stars)
    res ? res.round(1) : nil
  end

  def as_json(opts)
    super.merge(avg_rating: avg_rating)
  end
end
