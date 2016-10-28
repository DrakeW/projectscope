Rails.application.routes.draw do
  resources :users, :only => [:show], :path => "u" do
  	member do 
  		post :update_preference
  	end
  end
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:password]
  
  resources :projects
  root 'projects#index'
end
