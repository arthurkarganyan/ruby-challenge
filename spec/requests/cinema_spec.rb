describe Cinema::Api do
  let(:parsed_body) do
    JSON.parse(response.body)
  end

  let(:user1) do
    User.create(email: FFaker::Internet.email, password: FFaker::Internet.password, role: :moviegoer)
  end

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

  # context 'GET /api/statuses/:id' do
  #   it 'returns a status by id' do
  #     status = Status.create!
  #     get "/api/statuses/#{status.id}"
  #     expect(response.body).to eq status.to_json
  #   end
  # end
end