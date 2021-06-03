module Cinema
  class Root < Grape::API
    mount Cinema::Api
    add_swagger_documentation
  end
end
