DeadOrAlive::Engine.routes.draw do
  root to: 'usage#actions'
  get 'usage/actions',      controller: :usage, action: :actions
  get 'usage/workers',      controller: :usage, action: :workers
end
