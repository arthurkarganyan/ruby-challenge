describe Cinema::Api do
  let(:parsed_body) do
    JSON.parse(response.body)
  end

  let(:user1) {User.create(email: user1_email, password: user1_password, role: :moviegoer)}
  let(:user1_email) {FFaker::Internet.email}
  let(:user1_password) {FFaker::Internet.password}

  let(:user2) do
    User.create(email: FFaker::Internet.email, password: FFaker::Internet.password, role: :moviegoer)
  end

  let(:user3) do
    User.create(email: FFaker::Internet.email, password: FFaker::Internet.password, role: :moviegoer)
  end

  context 'GET /api/films' do
    before do
      Film.create!(title: FFaker::Movie.title, runtime_min: rand(30..120), released: rand(2000..2020))
      Film.create!(title: FFaker::Movie.title, runtime_min: rand(30..120), released: rand(2000..2020))
      Film.create!(title: FFaker::Movie.title, runtime_min: rand(30..120), released: rand(2000..2020))
    end

    it 'returns a list of films available' do
      get '/api/films'
      expect(response.status).to eq(200)
      expect(parsed_body.size).to eq(3)
    end

    it '#avg_rating is available' do
      film = Film.last
      FilmReview.create!(film: film, user: user1, stars: 5)
      FilmReview.create!(film: film, user: user2, stars: 4)
      get '/api/films'
      expect(response.status).to eq(200)
      expect(parsed_body[-1]['avg_rating']).to eq("4.5")
    end
  end

  context 'GET /api/films/:imdb_id' do
    let(:title) do
      "Terminator"
    end

    let(:film) do
      Film.create!(title: title,
                   runtime_min: rand(30..120),
                   released: rand(2000..2020),
                   imdb_id: "tt" + Array.new(7) {rand(9)}.join)
    end


    it "404" do
      get "/api/films/404"
      expect(response.status).to eq(404)
    end

    it "correct info is loaded" do
      get "/api/films/#{film.imdb_id}"
      expect(response.status).to eq(200)
      expect(parsed_body["title"]).to eq(title)
    end

    describe "film review" do
      it do
        expect(film.avg_rating).to eq(nil)
        user1
        headers = {"HTTP_AUTHORIZATION" => ("Basic " + Base64::encode64("#{user1_email}:#{user1_password}"))}
        post "/api/films/#{film.imdb_id}/rate", params: {stars: 5}, headers: headers
        expect(response.status).to eq(201)
        expect(film.avg_rating).to eq(5)
      end
    end
  end
end