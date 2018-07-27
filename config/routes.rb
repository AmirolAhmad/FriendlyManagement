Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post :friendships, to: 'friendships#create'
  get :friendlist, to: 'friendships#list'
  get :common, to: 'friendships#common'
end
