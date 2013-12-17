Rails.application.routes.draw do
  mount Subscribem::Engine => "/"

  get "/things" => "things#index", as: :things
end
