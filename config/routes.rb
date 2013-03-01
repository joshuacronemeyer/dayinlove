Dayinlove::Application.routes.draw do
  match 'pages/home' => 'pages#home', :as => :home
  match 'auth' => 'pages#auth'
  match '/auth/twitter/callback', to: 'pages#auth'
  root :to => 'pages#home'
end
