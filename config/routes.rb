Dayinlove::Application.routes.draw do
  match 'pages/home' => 'pages#home', :as => :home
  root :to => 'pages#home'
end
