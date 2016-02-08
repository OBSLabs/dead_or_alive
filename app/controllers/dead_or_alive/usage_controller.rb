module DeadOrAlive
  class DeadOrAlive::UsageController < DeadOrAlive::ApplicationController
    def index
      since = (params[:since]||7).to_i.days
      @actions = DeadOrAlive::ControllerRepo.new.actions(since)
    end
  end
end
