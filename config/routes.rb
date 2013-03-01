Dayinlove::Application.routes.draw do
  match 'pages/home' => 'pages#home', :as => :home
  match 'auth' => 'pages#auth'
  root :to => 'pages#home'
end
