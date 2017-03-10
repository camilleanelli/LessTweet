Rails.application.routes.draw do
  root "page#index"
  get '/page/user', to: "page#show", as: "page"
end
