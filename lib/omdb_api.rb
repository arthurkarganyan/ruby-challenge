class OmdbApi
  include HTTParty
  base_uri 'http://www.omdbapi.com'
  attr_reader :api_key

  def initialize
    @api_key = ENV['OMDB_API_KEY'] || fail("OMDB_API_KEY not provided")
  end

  def film_info(imdb_id)
    res = self.class.get("/", {query: {i: imdb_id, apikey: api_key}})
    res.parsed_response
  end
end