require 'rails_helper'

RSpec.describe Film, type: :model do
  describe "#cinema_timeslot_duration" do
    subject do
      Film.new(title: FFaker::Movie.title, runtime_min: runtime_min)
    end

    describe "duration_min=3" do
      let(:runtime_min) {3}

      it do
        expect(subject.cinema_timeslot_duration).to eq(30.minutes)
      end
    end

    describe "duration_min=30" do
      let(:runtime_min) {30}

      it do
        expect(subject.cinema_timeslot_duration).to eq(45.minutes)
      end
    end

    describe "duration_min=97" do
      let(:runtime_min) {97}

      it do
        expect(subject.cinema_timeslot_duration).to eq(120.minutes)
      end
    end
  end

  describe "#new_from_omdb_api" do
    let(:omdb_api_response) do
      {"Title" => "The Fast and the Furious",
       "Year" => "2001",
       "Rated" => "PG-13",
       "Released" => "22 Jun 2001",
       "Runtime" => "106 min",
       "Genre" => "Action, Crime, Thriller",
       "Director" => "Rob Cohen",
       "Writer" => "Ken Li (magazine article \"Racer X\"), Gary Scott Thompson (screen story), Gary Scott Thompson (screenplay), Erik Bergquist (screenplay), David Ayer (screenplay)",
       "Actors" => "Paul Walker, Vin Diesel, Michelle Rodriguez, Jordana Brewster",
       "Plot" => "Los Angeles police officer Brian O'Conner must decide where his loyalty really lies when he becomes enamored with the street racing world he has been sent undercover to destroy.",
       "Language" => "English, Spanish",
       "Country" => "USA, Germany",
       "Awards" => "11 wins & 18 nominations.",
       "Poster" => "https://m.media-amazon.com/images/M/MV5BNzlkNzVjMDMtOTdhZC00MGE1LTkxODctMzFmMjkwZmMxZjFhXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_SX300.jpg",
       "Ratings" => [{"Source" => "Internet Movie Database", "Value" => "6.8/10"}, {"Source" => "Rotten Tomatoes", "Value" => "53%"}, {"Source" => "Metacritic", "Value" => "58/100"}],
       "Metascore" => "58",
       "imdbRating" => "6.8",
       "imdbVotes" => "354,474",
       "imdbID" => "tt0232500",
       "Type" => "movie",
       "DVD" => "10 Sep 2015",
       "BoxOffice" => "$144,533,925",
       "Production" => "Universal Pictures, Neal H. Moritz Productions, Original Film",
       "Website" => "N/A",
       "Response" => "True"}
    end

    subject do
      f = Film.new_from_omdb_api omdb_api_response
      f.save!
      f.reload
    end

    it "#title" do
      expect(subject.title).to eq("The Fast and the Furious")
    end

    it "#year" do
      expect(subject.year).to eq(2001)
    end

    it "#rated" do
      expect(subject.rated).to eq("PG-13")
    end

    it "#released" do
      expect(subject.released.year).to eq(2001)
      expect(subject.released.month).to eq(6)
      expect(subject.released.day).to eq(22)
    end

    it "#runtime" do
      expect(subject.runtime_min).to eq(106)
    end

    it "#genre" do
      expect(subject.genre).to eq("Action, Crime, Thriller")
    end

    it "#director" do
      expect(subject.director).to eq("Rob Cohen")
    end

    it "#writer" do
      expect(subject.writer).to eq("Ken Li (magazine article \"Racer X\"), Gary Scott Thompson (screen story), Gary Scott Thompson (screenplay), Erik Bergquist (screenplay), David Ayer (screenplay)")
    end

    it "#actors" do
      expect(subject.actors).to eq("Paul Walker, Vin Diesel, Michelle Rodriguez, Jordana Brewster")
    end

    it "#plot" do
      expect(subject.plot).to eq("Los Angeles police officer Brian O'Conner must decide where his loyalty really lies when he becomes enamored with the street racing world he has been sent undercover to destroy.")
    end

    it "#language" do
      expect(subject.language).to eq("English, Spanish")
    end

    it "#country" do
      expect(subject.country).to eq("USA, Germany")
    end

    it "#awards" do
      expect(subject.awards).to eq("11 wins & 18 nominations.")
    end

    it "#poster" do
      expect(subject.poster_url).to eq("https://m.media-amazon.com/images/M/MV5BNzlkNzVjMDMtOTdhZC00MGE1LTkxODctMzFmMjkwZmMxZjFhXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_SX300.jpg")
    end

    it "#ratings" do
      expect(subject.ratings[0]["source"]).to eq("Internet Movie Database")
      expect(subject.ratings[1]["source"]).to eq("Rotten Tomatoes")
      expect(subject.ratings[2]["source"]).to eq("Metacritic")
      expect(subject.ratings[0]["value"]).to eq("6.8/10")
      expect(subject.ratings[1]["value"]).to eq("53%")
      expect(subject.ratings[2]["value"]).to eq("58/100")
    end

    it "#metascore" do
      expect(subject.metascore).to eq(58)
    end

    it "#imdb_rating" do
      expect(subject.imdb_rating).to eq(6.8)
    end

    it "#imdb_votes" do
      expect(subject.imdb_votes).to eq(354474)
    end

    it "#imdb_id" do
      expect(subject.imdb_id).to eq("tt0232500")
    end

    it "#film_type" do
      expect(subject.film_type).to eq("movie")
    end

    it "#released_on_dvd" do
      expect(subject.released_on_dvd.year).to eq(2015)
      expect(subject.released_on_dvd.month).to eq(9)
      expect(subject.released_on_dvd.day).to eq(10)
    end

    it "#box_office" do
      expect(subject.box_office).to eq("$144,533,925")
    end

    it "#production" do
      expect(subject.production).to eq("Universal Pictures, Neal H. Moritz Productions, Original Film")
    end

    it "#website" do
      expect(subject.website).to eq("N/A")
    end
  end

  describe 'validations' do
    it '#title' do
      record = Film.new
      record.title = '' # invalid state
      record.validate
      expect(record.errors[:title]).to include("can't be blank")
    end
    it '#released' do
      record = Film.new
      record.released = nil
      record.validate
      expect(record.errors[:released]).to include("can't be blank")
    end
    it '#runtime_min' do
      record = Film.new
      record.runtime_min = nil
      record.validate
      expect(record.errors[:runtime_min]).to include("can't be blank")
      record.runtime_min = 0
      record.validate
      expect(record.errors[:runtime_min]).to include("must be greater than 0")
    end
  end
end
