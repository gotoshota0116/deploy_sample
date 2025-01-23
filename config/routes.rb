Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'staticpages#top'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  
  get 'images/ogp.png', to: 'images#ogp', as: 'images_ogp'
  # asをつかうことで、images_ogp_pathのヘルパーを使うことができる。resourceなどは自動でヘルパーを生成してくれる。
  # OGPのルーティング

  # Defines the root path route ("/")
  # root "posts#index"
end
