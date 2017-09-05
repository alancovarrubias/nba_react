Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/api' do
    resources :seasons
    resources :teams
    resources :players
    resources :game_dates
    resources :games
    resources :periods
    resources :stats
  end
end
