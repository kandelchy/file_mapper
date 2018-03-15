Rails.application.routes.draw do
  resources :fields do
    collection {post :import }
    collection {post :import2}
    collection {post :import3}
    collection {post :import4}
    collection do
      get :edit_multiple
      put :update_multiple
      put :save_yaml
      get :map_file
      get :create_file
    end
  end

  # get "/path/to/your/mission/page", to: "static_pages#mission", as: "mission"


  root to: "fields#index"
end
