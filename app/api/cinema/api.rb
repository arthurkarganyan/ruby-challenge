module Cinema
  class Api < Grape::API
    version 'v1', using: :header, vendor: "dev"
    format :json
    prefix :api

    # TODO should I add users?
    # helpers do
    #   def current_user
    #     @current_user ||= User.authorize!(env)
    #   end
    #
    #   def authenticate!
    #     error!('401 Unauthorized', 401) unless current_user
    #   end
    # end
    #
    #

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
        post :rate do
          # TODO
        end
      end
    end

    # An internal endpoint in which they (i.e. the cinema owners) can update show times and prices for their movie catalog
  #   resource :show_times do
  #     get do
  #       # TODO index
  #     end
  #
  #     # desc 'Return a status.'
  #     # params do
  #     #   requires :id, type: Integer, desc: 'Status ID.'
  #     # end
  #     # route_param :id do
  #     #   get do
  #     #     Status.find(params[:id])
  #     #   end
  #     # end
  #
  #     desc 'Return a public timeline.'
  #     get :public_timeline do
  #       Status.limit(20)
  #     end
  #
  #     desc 'Return a personal timeline.'
  #     get :home_timeline do
  #       authenticate!
  #       current_user.statuses.limit(20)
  #     end
  #
  #
  #     desc 'Create a status.'
  #     params do
  #       requires :status, type: String, desc: 'Your status.'
  #     end
  #     post do
  #       authenticate!
  #       Status.create!({
  #                          user: current_user,
  #                          text: params[:status]
  #                      })
  #     end
  #
  #     desc 'Update a status.'
  #     params do
  #       requires :id, type: String, desc: 'Status ID.'
  #       requires :status, type: String, desc: 'Your status.'
  #     end
  #     put ':id' do
  #       authenticate!
  #       current_user.statuses.find(params[:id]).update({
  #                                                          user: current_user,
  #                                                          text: params[:status]
  #                                                      })
  #     end
  #
  #     desc 'Delete a status.'
  #     params do
  #       requires :id, type: String, desc: 'Status ID.'
  #     end
  #     delete ':id' do
  #       authenticate!
  #       current_user.statuses.find(params[:id]).destroy
  #     end
  #   end
  end
end
