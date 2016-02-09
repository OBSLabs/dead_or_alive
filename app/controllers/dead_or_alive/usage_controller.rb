module DeadOrAlive
  class DeadOrAlive::UsageController < DeadOrAlive::ApplicationController
    def actions
      @actions = DeadOrAlive::ControllerRepo.new.actions(since)
      render action: "index"
    end

    def workers
      @actions = DeadOrAlive::ControllerRepo.new.workers(since)
      render action: "index"
    end

    def since
      (params[:since]||7).to_i.days
    end
  end
end
