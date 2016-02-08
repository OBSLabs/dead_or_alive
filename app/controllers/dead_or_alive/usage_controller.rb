module DeadOrAlive
  class DeadOrAlive::UsageController < DeadOrAlive::ApplicationController
    def index
      @actions = DeadOrAlive::ControllerRepo.new.actions
    end
  end
end
