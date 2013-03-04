Dayinlove::Application.routes.draw do
  match 'pages/home' => 'pages#home', :as => :home
  match '/auth/twitter/callback', to: 'pages#auth'
  match '/auth/failure', to: 'pages#auth_failed'
  root :to => 'pages#home'
end
