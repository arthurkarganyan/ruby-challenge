module Cinema
  class Api < Grape::API
    version 'v1', using: :header, vendor: "dev"
    format :json
    prefix :api

    helpers do
      def current_user
        email, password = Base64::decode64(headers["Authorization"].gsub("Basic ", '')).split(':')
        user = User.find_by_email(email)
        return nil unless user
        @current_user ||= user.authenticate password
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end

      def ensure_cinema_owner!
        authenticate!
        error!('403 Forbidden', 403) unless current_user.cinema_owner?
      end
    end

    resources :films do
      get do
        Film.all
      end

      params do
        requires :imdb_id, type: String, desc: 'Film IMDB ID.'
      end
      route_param :imdb_id do
        before do
          @film = Film.find_by_imdb_id(params[:imdb_id])
          error!('404 Not Found', 404) unless @film
        end

        desc "An endpoint in which their customers (i.e. moviegoers) can fetch details about one of their movies (e.g. name, description, release date, rating, IMDb rating, and runtime). Even though there's a limited offering, please use the OMDb APIs (detailed below) to demonstrate how to communicate across APIs."
        get do
          @film
        end

        desc "An endpoint in which their customers (i.e. moviegoers) can leave a review rating (from 1-5 stars) about a particular movie"
        params do
          requires :stars, type: Integer, desc: 'rating for the film: 1, 2, 3, 4 or 5', values: [1, 2, 3, 4, 5]
        end
        post :rate do
          FilmReview.create!(stars: params[:stars], film: @film, user: current_user)
        end
      end
    end

    # An internal endpoint in which they (i.e. the cinema owners) can update show times and prices for their movie catalog
    resource :show_times do
      # get do
      #   # TODO index
      # end

      desc 'Create a show time.'
      params do
        requires :price, type: Integer, desc: 'Price for the ticket.'
        requires :start_time, type: String, desc: 'Date and time for start.'
        requires :film_imdb_id, type: String, desc: 'IMDB ID of the film'
      end

      post do
        ensure_cinema_owner!

        film = Film.find_by_imdb_id(params[:film_imdb_id])
        error!('404 Film Not Found', 404) unless film

        price = params[:price]
        error!('400 Price should be greater then 0', 400) unless price > 0

        start_time = DateTime.parse(params[:start_time])
        error!('400 Start time should be in the future', 400) unless start_time > DateTime.now

        ShowTime.build(start_time: start_time, film: film, price: price).save!
      end

      params do
        requires :id, type: Integer, desc: 'Show Time ID'
      end
      route_param :id do
        before do
          @show_time = ShowTime.find(params[:id])
        end

        desc 'Update a show time.'
        params do
          optional :price, type: Integer, desc: 'Price for the ticket.'
          optional :start_time, type: String, desc: 'Date and time for start.'
        end

        put do
          ensure_cinema_owner!

          if params[:price]
            price = params[:price]
            error!('400 Price should be greater then 0', 400) unless price > 0
            @show_time.price = price
          end

          if params[:start_time]
            start_time = DateTime.parse(params[:start_time])
            error!('400 Start time should be in the future', 400) unless start_time > DateTime.now
            end_time = start_time + @show_time.film.show_time_duration
            @show_time.start_time = start_time
            @show_time.end_time = end_time
          end

          @show_time.save!
        end
      end
    end
  end
end
