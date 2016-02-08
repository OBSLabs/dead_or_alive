DeadOrAlive::Engine.routes.draw do
  root to: 'usage#index'
  get 'usage/index',      controller: :usage, action: :index
end
