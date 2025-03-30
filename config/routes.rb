Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # 認証関連
      post "/login", to: "auth#login"
      post "/signup", to: "auth#signup"

      # 開発環境のみのテスト用ルート
      if Rails.env.development?
        get "/test_token", to: "auth#test_token"
      end
    end
  end
end
