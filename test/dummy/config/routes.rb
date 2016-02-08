Rails.application.routes.draw do

  mount DeadOrAlive::Engine => "/dead_or_alive"
end
