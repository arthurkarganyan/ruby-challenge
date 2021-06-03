describe Cinema::Api do
  let(:parsed_body) do
    JSON.parse(response.body)
  end

  let(:moviegoer1) {User.create(email: FFaker::Internet.email, password: moviegoer1_password, role: :moviegoer)}
  let(:moviegoer1_password) {FFaker::Internet.password}

  let(:moviegoer2) do
    User.create(email: FFaker::Internet.email, password: FFaker::Internet.password, role: :moviegoer)
  end

  let(:moviegoer3) do
    User.create(email: FFaker::Internet.email, password: FFaker::Internet.password, role: :moviegoer)
  end

  let(:cinema_owner1) do
    User.create(email: FFaker::Internet.email, password: cinema_owner1_password, role: :cinema_owner)
  end
  let(:cinema_owner1_password) {FFaker::Internet.password}

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
      FilmReview.create!(film: film, user: moviegoer1, stars: 5)
      FilmReview.create!(film: film, user: moviegoer2, stars: 4)
      get '/api/films'
      expect(response.status).to eq(200)
      expect(parsed_body[-1]['avg_rating']).to eq("4.5")
    end
  end

  let(:title) do
    "Terminator"
  end

  let(:film) do
    Film.create!(title: title,
                 runtime_min: runtime_min,
                 released: rand(2000..2020),
                 imdb_id: "tt" + Array.new(7) {rand(9)}.join)
  end

  context 'GET /api/films/:imdb_id' do
    let(:runtime_min) {rand(30..120)}

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
        headers = {"HTTP_AUTHORIZATION" => ("Basic " + Base64::encode64("#{moviegoer1.email}:#{moviegoer1_password}"))}
        post "/api/films/#{film.imdb_id}/rate", params: {stars: 5}, headers: headers
        expect(response.status).to eq(201)
        expect(film.avg_rating).to eq(5)
      end
    end
  end

  context '/api/show_times' do
    let(:runtime_min) {111}
    it "cinema_owner permission check for creation of show time" do
      headers = {"HTTP_AUTHORIZATION" => ("Basic " + Base64::encode64("#{moviegoer1.email}:#{moviegoer1_password}"))}
      post "/api/show_times", params: {price: 10,
                                       film_imdb_id: film.imdb_id,
                                       start_time: "10 Dec 2021 21:00"}, headers: headers
      expect(response.status).to eq(403)
    end

    it "cinema_owner permission check for update of show time" do
      s = ShowTime.build_and_save!(film: film, price: 10, start_time: '10 Dec 2021 21:00')
      headers = {"HTTP_AUTHORIZATION" => ("Basic " + Base64::encode64("#{moviegoer1.email}:#{moviegoer1_password}"))}
      put "/api/show_times/#{s.id}", params: {price: 20}, headers: headers
      expect(response.status).to eq(403)
    end

    context "cinema owner" do
      let(:headers) do
        {"HTTP_AUTHORIZATION" => ("Basic " + Base64::encode64("#{cinema_owner1.email}:#{cinema_owner1_password}"))}
      end

      it "wrong film id" do
        post "/api/show_times", params: {price: 10,
                                         film_imdb_id: "404",
                                         start_time: "10 Dec 2021 21:00"}, headers: headers
        expect(response.status).to eq(404)
      end

      it "wrong price" do
        post "/api/show_times", params: {price: -10,
                                         film_imdb_id: film.imdb_id,
                                         start_time: "10 Dec 2021 21:00"}, headers: headers
        expect(response.status).to eq(400)
        expect(parsed_body["error"]).to include("Price should be greater then 0")
      end

      it "wrong start_time" do
        post "/api/show_times", params: {price: 10,
                                         film_imdb_id: film.imdb_id,
                                         start_time: "10 Dec 2019 21:00"}, headers: headers
        expect(response.status).to eq(400)
        expect(parsed_body["error"]).to include("Start time should be in the future")
      end

      it "positive case" do
        post "/api/show_times", params: {price: 10,
                                         film_imdb_id: film.imdb_id,
                                         start_time: "10 Dec 2021 21:00"}, headers: headers
        expect(response.status).to eq(201)
        expect(ShowTime.count).to eq(1)
        expect(ShowTime.last.end_time).to eq(DateTime.parse("10 Dec 2021 23:15"))
      end

      it "update price" do
        s = ShowTime.build_and_save!(film: film, price: 10, start_time: '10 Dec 2021 21:00')
        headers = {"HTTP_AUTHORIZATION" => ("Basic " + Base64::encode64("#{cinema_owner1.email}:#{cinema_owner1_password}"))}
        put "/api/show_times/#{s.id}", params: {price: 20}, headers: headers
        expect(response.status).to eq(200)
        s.reload
        expect(s.price).to eq(20)
      end

      it "update start time" do
        s = ShowTime.build_and_save!(film: film, price: 10, start_time: '10 Dec 2021 21:00')
        headers = {"HTTP_AUTHORIZATION" => ("Basic " + Base64::encode64("#{cinema_owner1.email}:#{cinema_owner1_password}"))}
        put "/api/show_times/#{s.id}", params: {start_time: '10 Dec 2021 20:00'}, headers: headers
        expect(response.status).to eq(200)
        s.reload
        expect(s.start_time).to eq(DateTime.parse "10 Dec 2021 20:00")
        expect(s.end_time).to eq(DateTime.parse "10 Dec 2021 22:15")
      end
    end
  end
end