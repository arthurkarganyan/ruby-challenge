class OmdbApi
  include HTTParty
  base_uri 'http://www.omdbapi.com'

  def film_info(imdb_id)
    res = self.class.get("/", {query: {i: imdb_id, apikey: ENV['OMDB_API_KEY']}})
    res.parsed_response
  end
end