Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # 認証関連
      post "/login", to: "auth#login"
      post "/signup", to: "auth#signup"

      resource :profile, only: [:show, :create, :update]

      resources :github_activities, only: [:index] do
        collection do
          get :fetch
          get :repositories
          get :commits
          get :profile
        end
      end
    end
  end
end
