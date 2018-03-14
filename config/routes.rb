Rails.application.routes.draw do
  resources :fields do
    collection { post :import }
    collection {post :import2}
    collection do
      get :edit_multiple
      put :update_multiple
      put :save_yaml
    end
  end

  get "/path/to/your/mission/page", to: "static_pages#mission", as: "mission"

  #  root to: "headers#index"
  root to: "fields#index"
end
